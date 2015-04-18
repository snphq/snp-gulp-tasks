browserSync = require "browser-sync"
PROP = require "../lib/config"

baseDir = [PROP.path.build()]
baseDir.push PROP.path.app if PROP.isDev

opts = PROP.browserSync
opts.server = {
  baseDir
  index: "index.html"
  routes: {
    "/bower_components": "bower_components"
    "/images": "images"
  }
}

module.exports = -> browserSync opts
