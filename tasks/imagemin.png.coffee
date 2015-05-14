pngquant = require "imagemin-pngquant"
optipng = require "imagemin-optipng"
size = require "gulp-size"
cache = require "gulp-cache"

PROP = require "../lib/config"

module.exports = ->
  gulp.src PROP.path.images "png"
    .pipe size {title: "PNG"}
    .pipe cache (optipng optimizationLevel: 3)()
    .pipe cache (pngquant quality: "65-80", speed: 4)()
    .pipe size {title: "PNG(imagemin)"}
    .pipe gulp.dest PROP.path.images "dest"
