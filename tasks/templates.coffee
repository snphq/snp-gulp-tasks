browserSync = require 'browser-sync'
PROP = require '../lib/config'
helpers = require '../lib/helpers'
$ = helpers.gulpLoad [
  'if'
  'ignore'
  'jade'
  'plumber'
]

module.exports = ->
  condition = '**/_*.jade'
  stream = gulp.src PROP.path.templates()
  .pipe $.if PROP.isNotify, $.plumber
    errorHandler: helpers.errorHandler
  .pipe $.ignore.exclude(condition)
  .pipe $.jade PROP.jade.options()
  .pipe gulp.dest PROP.path.templates 'dest'
  if PROP.isSrv
    stream.pipe browserSync.stream()
  stream
