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

module.exports =
  deps: []
  fn: (cb)->
    new WebpackDevServer (webpack webpackConfig), {
      publicPath: webpackConfig.output.publicPath,
      filename: 'bundle.js'
      inline: true
      hot: true
      stats:
        colors: true
    }
    # .listen 8080, 'localhost', (err)->
    #   throw new gutil.PluginError('webpack-dev-server', err) if err
    #   cb()
