PROP = require "../lib/config"
RevAll = require "gulp-rev-all"
gif = require "gulp-if"

opts = {
 dontGlobal: [ /^\/favicon.ico$/g, /\/robots.txt$/g, /^\/files\//g ],
 dontRenameFile: ["\.html"]
 dontUpdateReference: ["\.html"]
 dontSearchFile: ["\/modernizr\/modernizr\.js"]
 prefix: PROP.cdn.host
}

revAll = new RevAll opts

module.exports = ->
 re_pdf = /\.pdf$/
 condition = (f)->
   not re_pdf.test f.path
 gulp.src PROP.path.build_files()
   .pipe gif condition, revAll.revision()
   .pipe gulp.dest PROP.path.build()
