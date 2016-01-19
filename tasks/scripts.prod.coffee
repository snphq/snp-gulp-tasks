path = require 'path'
webpackConfig = (require path.resolve './webpack/build')()
webpack = require 'webpack'

module.exports = (cb)->
  webpack webpackConfig , -> cb()
