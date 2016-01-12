browserSync = require 'browser-sync'
PROP = require '../lib/config'
_ = require 'lodash'

baseDir = [PROP.path.build()]
baseDir.push PROP.path.app if PROP.isDev

opts = PROP.browserSync
opts = _.defaults opts, {
  logFileChanges: false
}


opts.server = {
  baseDir
  index: 'index.html'
  routes: {
    '/bower_components': 'bower_components'
    '/images': 'images'
  }
}

module.exports = -> browserSync opts
