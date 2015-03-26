PROP = require '../lib/config'
helpers = require '../lib/helpers'
$ = helpers.gulpLoad [
  'if'
  'rev'
]

module.exports = ->
  gulp.src PROP.path.images()
    .pipe $.if !PROP.isDev, $.rev.image()
    .pipe gulp.dest PROP.path.images("dest"), {mode: 0o644}
