jpegoptim = require "imagemin-jpegoptim"
PROP = require "../lib/config"

module.exports = ->
  gulp.src PROP.path.images "jpg"
    .pipe jpegoptim max: 70
    .pipe gulp.dest PROP.path.images "dest"
