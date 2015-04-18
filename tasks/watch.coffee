chokidar = require 'chokidar'
browserSync = require 'browser-sync'
PROP = require '../lib/config'
module.exports = ->


  chokidar.watch PROP.path.templates("watch")
    .on 'all', -> gulp.run 'templates'
  chokidar.watch PROP.path.styles("watch")
    .on 'all', -> gulp.run 'styles'
  chokidar.watch PROP.path.scripts("watch")
    .on 'all', -> gulp.run 'scripts'
  chokidar.watch PROP.path.livereload()
    .on "all", browserSync.reload
