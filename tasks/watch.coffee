browserSync = require 'browser-sync'
PROP = require '../lib/config'
module.exports = ->
  browserSync.watch PROP.path.templates 'watch'
    .on 'all', -> gulp.run 'templates'
  browserSync.watch PROP.path.styles 'watch'
    .on 'all', -> gulp.run 'styles'
  browserSync.watch PROP.path.livereload()
    .on 'all', browserSync.reload
