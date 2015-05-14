jpegoptim = require "imagemin-jpegoptim"
PROP = require "../lib/config"
size = require "gulp-size"
cache = require "gulp-cache"

module.exports = ->
  gulp.src PROP.path.images "jpg"
    .pipe size {title: "JPG"}
    .pipe cache (jpegoptim max: 70)()
    .pipe size {title: "JPG(imagemin)"}
    .pipe gulp.dest PROP.path.images "dest"
