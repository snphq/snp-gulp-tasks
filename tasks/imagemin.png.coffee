pngquant = require "imagemin-pngquant"
optipng = require "imagemin-optipng"

PROP = require "../lib/config"

module.exports = ->
  gulp.src PROP.path.images "png"
    .pipe optipng optimizationLevel: 3
    .pipe pngquant quality: "65-80", speed: 4
    .pipe gulp.dest PROP.path.images "dest"
