notify = require 'gulp-notify'
gutil = require 'gulp-util'
Stream = require 'stream'
module.exports =
  gulpLoad: (libs)->
    wrap = {}
    for l in libs
      try
        wrap[l] = require "gulp-#{l}"
      catch gulpPluginException
        try
          wrap[l] = require "../plugins/#{l}"
        catch
          throw new gutil.PluginError 'snp-gulp-tasks', gulpPluginException
    wrap
  errorHandler: (err)->
    notify.onError(
      title: 'Gulp'
      subtitle: 'Failure!'
      message: 'Error: <%= error.message %>'
      sound: 'Beep'
    )(err)
    gutil.log err
    @emit 'end'
  emptyStream: (fileName)->
    stream = Stream.Readable({ objectMode: true })
    stream._read = ->
      emptyBuffer = new gutil.File
        contents: new Buffer ''
        path: '/null/#{fileName}'
      @push emptyBuffer
      @push null
    stream
