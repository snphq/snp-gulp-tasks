PROP = require "../lib/config"
RevAll = require "gulp-rev-all"

opts = {
  dontRenameFile: [/^\/favicon.ico$/g, /^\/.+\.html/g]
  prefix: PROP.cdn.host
}


revAll = new RevAll

module.exports = ->
  gulp.src PROP.path.build_files()
    .pipe revAll.revision()
    .pipe gulp.dest PROP.path.build()
