require('coffee-script');
var _ = require('underscore');

var modules = [
    require('./js-misc'),
    require('./js-string'),
    require('./node-http-server'),
    require('./node-http-client'),
    require('./node-misc')
];

module.exports = {};
for (var i = 0, len = modules.length; i < len; i++) {
    module.exports = _.extend(module.exports, modules[i]);
}
