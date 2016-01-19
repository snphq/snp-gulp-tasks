path = require 'path'
helpers = require  '../lib/helpers'
webpackConfig = require path.resolve './webpack/dev'
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
gutil = require 'gulp-util'

libpath = require 'path'
$ = helpers.gulpLoad [
  'size'
]

PROP = require '../lib/config'

taskExecuted = false

module.exports = (cb)->
  if taskExecuted
    throw new gutil.PluginError 'snp-gulp-tasks', 'Scripts task was executed twice!'
  taskExecuted = true
  new WebpackDevServer (webpack webpackConfig), {
    publicPath: webpackConfig.output.publicPath,
    filename: 'bundle.js'
    inline: true
    hot: true
    stats:
      colors: true
  }
  .listen 8080, '127.0.0.1', (err)->
    throw new gutil.PluginError('webpack-dev-server', err) if err
    cb()
