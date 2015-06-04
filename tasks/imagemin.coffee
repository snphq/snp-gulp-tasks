imagemin = {
  pngquant: require "imagemin-pngquant"
  optipng: require "imagemin-optipng"
  jpegoptim: require "imagemin-jpegoptim"
}
helpers = require "../lib/helpers"
PROP = require "../lib/config"
$ = helpers.gulpLoad [
  'size'
  'cache'
  'filter'
  'clone'
  'unretina'
  'rename'
]

exts = ['jpg', 'jpeg', 'png']

procDownScale = (stream, from, to)->
  patterns = ("**/*#{from}.#{ext}" for ext in exts)
  cloneSink = $.clone.sink()
  filterRetina = $.filter patterns
  stream
    .pipe filterRetina
    .pipe cloneSink
    .pipe $.unretina {suffix: false}
    .pipe $.rename (path)->
      path.basename = path.basename.replace from, to
      undefined
    .pipe cloneSink.tap()
    .pipe filterRetina.restore()


module.exports = ->
  stream = gulp.src PROP.path.images 'raster'
    .pipe $.size {title: "All source images"}
  stream = procDownScale stream, "@4x", "@2x"
  stream = procDownScale stream, "@2x", ""
  stream.pipe $.size {title: "All retinized images"}
  stream.pipe gulp.dest PROP.path.images 'dest'

# todo: учесть старый images 0x644
