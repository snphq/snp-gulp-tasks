libpath = require 'path'
through2 = require 'through2'
helpers = require '../lib/helpers'

$ = helpers.gulpLoad [
  'if'
  'sourcemaps'
  'uglify'
]
PROP = require '../lib/config'

module.exports = ->
  gulp.src PROP.path.scripts("extras_src")
    .pipe through2.obj (file, enc, callback)->
      file.base = libpath.resolve file.base, "../"
      @push file
      callback()
    .pipe $.sourcemaps.init {loadMaps: true}
    .pipe $.if !PROP.isDev, $.uglify()
    .pipe $.sourcemaps.write(".")
    .pipe gulp.dest PROP.path.scripts("extras_dest")
