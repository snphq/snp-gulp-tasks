PROP = require "../lib/config"
RevAll = require "gulp-rev-all"

opts = {
  dontGlobal: [ /^\/favicon.ico$/g, /\/robots.txt$/g ],
  dontRenameFile: [ "\.html" ]
  prefix: PROP.cdn.host
}

revAll = new RevAll opts

module.exports = ->
  gulp.src PROP.path.build_files()
    .pipe revAll.revision()
    .pipe gulp.dest PROP.path.build()
