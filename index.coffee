module.exports = (gulp)->
  global.gulp = gulp
  gutil = require "gulp-util"
  gulpsync = require("gulp-sync")(gulp)
  _ = require "lodash"
  fs = require "fs"
  libpath = require "path"

  PROP = require "./config"

  tasksDir =   libpath.resolve __dirname, './tasks/'
  tasksDict = {}
  tasks = fs.readdirSync tasksDir


  for task in tasks
    {name} = (libpath.parse task)
    console.log name
    tasksDict[name] = libpath.join tasksDir, task

  for taskName, path of tasksDict
    taskModule = require path
    if _.isFunction taskModule
      console.log "function: #{taskName}"
      gulp.task taskName, taskModule
    else if _.isObject taskModule and (taskModule.fn or taskModule.deps)
      console.log "object: #{taskName}"
      args = [taskName]
      args.push taskModule.deps if taskModule.deps
      args.push taskModule.fn if taskModule.fn
      gulp.task.apply gulp, args
    else
      console.log "else: #{taskName}"
      gutil.log taskModule
      gutil.log  gutil.colors.red "Gulp task load: wrong task structure #{taskName}: #{path}"