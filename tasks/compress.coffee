gzip = require 'gulp-gzip'
PROP = require '../lib/config'
libpath = require 'path'

module.exports = ->
  gulp.src libpath.join PROP.path.build(), "**", "*.{html,js,css}"
    .pipe gzip()
    .pipe gulp.dest PROP.path.build()
