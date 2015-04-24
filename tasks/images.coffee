PROP = require '../lib/config'
helpers = require '../lib/helpers'

module.exports = ->
  gulp.src PROP.path.images()
    .pipe gulp.dest PROP.path.images("dest"), {mode: 0o644}
