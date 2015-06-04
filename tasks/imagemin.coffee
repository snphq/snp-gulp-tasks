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

makeFilterNoOpt = -> $.filter (file)->
    not /\.noopt\./.test file.path

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

procPNG = (stream)->
  filterNoOpt = makeFilterNoOpt()
  filterPNG = $.filter "**/*.png"
  stream
    .pipe filterPNG
    .pipe $.size {title: "PNG"}
    .pipe filterNoOpt
    .pipe (imagemin.optipng optimizationLevel: 3)()
    .pipe (imagemin.pngquant quality: "65-80", speed: 4)()
    # todo: repair caching
    # .pipe $.cache (imagemin.optipng optimizationLevel: 3)()
    # .pipe $.cache (imagemin.pngquant quality: "65-80", speed: 4)()
    .pipe filterNoOpt.restore()
    .pipe $.size {title: "PNG(imagemin)"}
    .pipe filterPNG.restore()

procJPG = (stream)->
  filterNoOpt = makeFilterNoOpt()
  filterJPG = $.filter ["**/*.jpg", "**/*.jpeg"]
  stream
    .pipe filterJPG
    .pipe $.size {title: "JPG"}
    .pipe filterNoOpt
    .pipe (imagemin.jpegoptim max: 70)()
    # todo: repair caching
    # .pipe $.cache (jpegoptim max: 70)()
    .pipe filterNoOpt.restore()
    .pipe $.size {title: "JPG(imagemin)"}
    .pipe filterJPG.restore()

module.exports = ->
  stream = gulp.src PROP.path.images 'raster'
    .pipe $.size {title: "All source images"}
  stream = procDownScale stream, "@4x", "@2x"
  stream = procDownScale stream, "@2x", ""
  stream.pipe $.size {title: "All retinized images"}
  stream = procPNG stream if PROP.isImageMin
  stream = procJPG stream if PROP.isImageMin
  stream.pipe gulp.dest PROP.path.images 'dest'

# todo: учесть старый images 0x644
