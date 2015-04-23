PROP = require '../lib/config'

module.exports = ->
  gulp.src PROP.path.extras(), {dot: true, base: "app"}
    .pipe gulp.dest PROP.path.extras("dest"), {mode: 0o644}
