pngquant = require 'imagemin-pngquant'
optipng = require 'imagemin-optipng'
helpers = require '../lib/helpers'
$ = helpers.gulpLoad [
  'size'
  'cache'
  'filter'
]

PROP = require '../lib/config'

filterNoopt = $.filter ((file)->
  not /\.noopt\./.test file.path
), {restore: true}

module.exports = ->
  gulp.src PROP.path.images 'png'
    .pipe $.size {title: 'PNG'}
    .pipe filterNoopt
    .pipe $.cache (optipng optimizationLevel: 3)()
    .pipe $.cache (pngquant quality: '65-80', speed: 4)()
    .pipe filterNoopt.restore
    .pipe $.size {title: 'PNG(imagemin)'}
    .pipe gulp.dest PROP.path.images 'dest'
