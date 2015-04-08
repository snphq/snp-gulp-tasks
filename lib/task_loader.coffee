fs = require "fs"
libpath = require "path"
_ = require "lodash"

class TaskLoader
  tasksDict: null
  constructor: ->
    @tasksDict = {}

  collect: (tasksDir)->
    tasksDir = libpath.resolve tasksDir
    return unless fs.existsSync tasksDir
    for task in fs.readdirSync tasksDir
      ext = libpath.extname task
      name = libpath.basename task, ext
      continue unless ext is ".coffee"
      @tasksDict[name] = libpath.join tasksDir, task

  load: ->
    for taskName, path of @tasksDict
      taskModule = require path
      if _.isFunction taskModule
        gulp.task taskName, taskModule
      else if _.isObject taskModule and (taskModule.fn or taskModule.deps)
        args = [taskName]
        args.push taskModule.deps if taskModule.deps
        args.push taskModule.fn if taskModule.fn
        gulp.task.apply gulp, args
      else
        gutil.log gutil.colors.red "Gulp task load: wrong task structure #{taskName}: #{path}"

module.exports = TaskLoader
