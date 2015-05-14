pngquant = require "imagemin-pngquant"
optipng = require "imagemin-optipng"
helpers = require "../lib/helpers"
$ = helpers.gulpLoad [
  'size'
  'cache'
  'filter'
]

PROP = require "../lib/config"

module.exports = ->
  filter_noopt = $.filter (file)->
    not /\.noopt\./.test file.path
  gulp.src PROP.path.images "png"
    .pipe $.size {title: "PNG"}
    .pipe filter_noopt
    .pipe $.cache (optipng optimizationLevel: 3)()
    .pipe $.cache (pngquant quality: "65-80", speed: 4)()
    .pipe filter_noopt.restore()
    .pipe $.size {title: "PNG(imagemin)"}
    .pipe gulp.dest PROP.path.images "dest"
