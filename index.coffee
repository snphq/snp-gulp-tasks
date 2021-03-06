module.exports = (gulp)->
  global.gulp = gulp
  gulpsync = require('gulp-sync')(gulp)
  libpath = require 'path'

  TaskLoader = require './lib/task_loader'

  taskLoader = new TaskLoader
  taskLoader.collect libpath.resolve __dirname, './tasks/'
  taskLoader.collect './gulp/tasks/'
  taskLoader.load()
