jpegoptim = require "imagemin-jpegoptim"
PROP = require "../lib/config"
helpers = require "../lib/helpers"
$ = helpers.gulpLoad [
  'size'
  'cache'
  'filter'
]

module.exports = ->
  filter_noopt = $.filter (file)->
    not /\.noopt\./.test file.path

  gulp.src PROP.path.images "jpg"
    .pipe $.size {title: "JPG"}
    .pipe filter_noopt
    .pipe $.cache (jpegoptim max: 70)()
    .pipe filter_noopt.restore()
    .pipe $.size {title: "JPG(imagemin)"}
    .pipe gulp.dest PROP.path.images "dest"
