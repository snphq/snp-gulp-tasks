helpers = require '../lib/helpers'
$ = helpers.gulpLoad [
  'if'
  'flatten'
]
PROP = require '../lib/config'

module.exports = ->
  gulp.src PROP.path.fonts()
    .pipe gulp.dest PROP.path.fonts("dest"), {mode: 0o644}
