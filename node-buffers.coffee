{timeoutSet} = require './js-misc'


# {start, end} always refer to the source stream,
# not the range we happen to have buffered


class CircularBuffer

  constructor: (@capacity) ->
    @_buffer = new Buffer @capacity
    @num_bytes_written = 0

  append: (data) ->
    throw new Error "Data exceeds capacity" if data.length > @capacity
    pos = @num_bytes_written % @capacity
    capacity_exceeded_by = pos + data.length - @capacity
    # Can we write without wrapping?
    if capacity_exceeded_by <= 0
      data.copy @_buffer, pos
    else
      first_source_end = data.length - capacity_exceeded_by
      data.copy @_buffer, pos,  0,                first_source_end
      data.copy @_buffer, 0,    first_source_end, data.length
    @num_bytes_written += data.length

  can_read_range: (start, end) ->
    (not (
            (end > @num_bytes_written) or
            (start < (@num_bytes_written - @capacity))))

  # Returns null or Buffer
  slice: (start, end) ->
    throw new Error "end is of bounds" if end > @num_bytes_written
    throw new Error "start is of bounds" if start < (@num_bytes_written - @capacity)
    size = end - start
    pos = start % @capacity
    capacity_exceeded_by = pos + size - @capacity
    # Wrap-free case?
    if capacity_exceeded_by <= 0
      @_buffer.slice pos, (pos + size)
    else
      result = new Buffer size
      first_size = size - capacity_exceeded_by
      @_buffer.copy result, 0,          pos,  (pos + first_size)
      @_buffer.copy result, first_size, 0,    capacity_exceeded_by
      result


class StreamBufferWithRecent

  constructor: ({@total_capacity, @stream, @history_capacity}) ->
    @history_capacity ?= 0
    @future_capacity = @total_capacity - @history_capacity
    @_cb = new CircularBuffer @total_capacity
    @num_bytes_obtained = 0
    @num_bytes_consumed = 0
    @slices_being_waited_for = []

    @stream.on 'data', (data) =>
      num_bytes_not_consumed = @num_bytes_obtained - @num_bytes_consumed
      capacity_exceeded_by = data.length + num_bytes_not_consumed - @future_capacity

      # Can we append it all?
      if capacity_exceeded_by <= 0
        @_cb.append data
        @num_bytes_obtained += data.length

      # Nope, just (0 <= n < length) of it.
      else
        @stream.pause()
        @_paused = true
        num_bytes_we_can_append = data.length - capacity_exceeded_by
        @_cb.append data.slice 0, num_bytes_we_can_append
        @num_bytes_obtained += num_bytes_we_can_append
        @stream.unshift data.slice num_bytes_we_can_append

      for k, [start, end, c] of @slices_being_waited_for
        if @can_read_range start, end
          c null
          delete @slices_being_waited_for[k]

  can_read_range: (start, end) ->
    @_cb.can_read_range start, end

  wait_for_range: (opt, c) ->
    {start, end, timeout} = opt
    throw new Error 'Missing param: start' if not start?
    throw new Error 'Missing param: end' if not end?

    if @can_read_range start, end
      return process.nextTick c

    key = "#{start}:#{end}"
    @slices_being_waited_for[key] = [start, end, c]
    if timeout?
      timeoutSet timeout, () =>
        delete @slices_being_waited_for[key]
        c new Error 'Timeout exceeded'

  slice: (start, end) ->
    slice = @_cb.slice start, end
    @num_bytes_consumed = end if end > @num_bytes_consumed
    num_bytes_not_consumed = @num_bytes_obtained - @num_bytes_consumed
    if @_paused and num_bytes_not_consumed < @future_capacity
      @stream.resume()
    slice


module.exports = {
  CircularBuffer
  StreamBufferWithRecent
}
