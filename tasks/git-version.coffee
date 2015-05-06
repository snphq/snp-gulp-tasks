gulp = require 'gulp'
gutil = require 'gulp-util'
exec = require('child_process').exec
PROP = require '../lib/config'
Stream = require 'stream'

module.exports = ->
  stream = Stream.Readable({ objectMode: true })
  written = false
  stream._read = ->
    exec 'git rev-parse HEAD', (err, stdout, stderr)=>
      if written
        @push null
        return
      versionFile = new gutil.File
        contents: new Buffer(stdout)
        path: "version.txt"
      gutil.log "Build version is #{stdout}"
      @push versionFile
      written = true
  stream.pipe gulp.dest PROP.path.build()
