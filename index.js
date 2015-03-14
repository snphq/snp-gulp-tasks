// Note the new way of requesting CoffeeScript since 1.7.x
require('coffee-script/register');

module.exports = function(gulp){
  require('./index.coffee')(gulp);
}
