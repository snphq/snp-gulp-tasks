sync = (require "gulp-sync") gulp
PROP = require '../lib/config'
DEFAULT_TASK = do ->
  build = ["clean"]
  build.push ["images", "fonts", "extras"] unless PROP.isDev
  build.push "sprites"
  build.push "cssimage"
  build.push "styles"
  build.push if PROP.isDev then "scripts" else "rjs"
  build.push "extras_js" unless PROP.isDev
  build.push "templates"
  build.push "bs" if PROP.isSrv
  build.push "proxy" if PROP.isSrv
  build.push "watch" if PROP.isSrv and PROP.isDev
  build.push "imagemin" if PROP.isImageMin
  build.push "revision" unless PROP.isDev
  build.push "git-version" unless PROP.isDev
  build.push "compress" unless PROP.isDev
  build

module.exports = {
  deps: sync.sync DEFAULT_TASK
}
