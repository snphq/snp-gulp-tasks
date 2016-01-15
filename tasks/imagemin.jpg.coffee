jpegoptim = require 'imagemin-jpegoptim'
PROP = require '../lib/config'
helpers = require '../lib/helpers'
$ = helpers.gulpLoad [
  'size'
  'cache'
  'filter'
]

filterNoopt = $.filter ((file)->
  not /\.noopt\./.test file.path
), {restore: true}

module.exports = ->
  gulp.src PROP.path.images 'jpg'
    .pipe $.size {title: 'JPG'}
    .pipe filterNoopt
    .pipe $.cache (jpegoptim max: 70)()
    .pipe filterNoopt.restore
    .pipe $.size {title: 'JPG(imagemin)'}
    .pipe gulp.dest PROP.path.images 'dest'
