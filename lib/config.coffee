gutil = require "gulp-util"
libpath = require "path"
through2 = require "through2"
mainbowerfiles = require "main-bower-files"
_ = require "lodash"
cfg = require libpath.resolve "./.gulpconfig"


cdn = _.defaults cfg.cdn, {
  host: ""
}

cfg.imagemin ?= true

cfg.browserSync ?= {}
browserSync = _.defaults cfg.browserSync, {
  reloadDelay: 500
  reloadDebounce: 2000
  port: 3000
  open: false
}

g_mode = ->
  gutil.env.mode || "dist"

PROP = do ->
  isDev = not (gutil.env.mode in ["dist", "prod"])

  isDev: isDev
  isSrv: not gutil.env.build
  isNotify: not gutil.env.build
  isImageMin: cfg.imagemin? and not isDev

  preprocess: (prop=gutil.env.mode)->
    context = switch prop
      when "dist" then {DIST:true}
      when "prod" then {PROD:true}
      else {DEBUG:true}
    {context}

  cdn: cdn
  browserSync: browserSync

  jade:
    mode: (prop=gutil.env.mode)->
      switch prop
        when "dist" then "dist"
        when "prod" then "production"
        else "server"
    options: ->
      result =
        basedir: PROP.path.app
        pretty: PROP.isDev
        data: jade_mode: PROP.jade.mode()
        filters:{}
      result

  amd:
    _options:
      preserveLicenseComments: false
      useStrict: true
      wrap: true
      name: "main"
    options: ->
      opts = _.merge PROP.amd._options, {
        baseUrl: PROP.path.scripts("dest")
        out: PROP.path.scripts("out")
      }
    optionsExtract: through2.obj (file, enc, callback)->
      rjs_content = """
        var output;
        var requirejs = require = function(){}
        require.config = function (options) { output = options; }
        var define = function () {};
        #{file.contents.toString(enc)}
        return output;
      """
      try
        amd_options = _.merge PROP.amd.options(), Function(rjs_content)()
        PROP.amd._options.paths = _.reduce amd_options.paths, ((memo, v, k)->
          memo[k] = v.replace /^\.\.\/bower_components\//, "../../app/bower_components/"
          memo
        ), {}
        @push file
        callback()
      catch e
        callback e

  sprites:
    __mixinsAdded: false
    __defaultOptions:
      algorithm: 'binary-tree'
      imgOpts:
        format: 'png'
      cssFormat: 'scss'
    get: (name)->
      settings = cfg.sprites[name] || {}
      settings = _.extend {}, PROP.sprites.__defaultOptions, settings
      settings.imgName ?= "#{name}.#{settings.imgOpts.format}"
      settings.cssName ?= "_#{name}.#{settings.cssFormat}"
      settings.imgPath ?= "/images/sprites/#{settings.imgName}"
      settings.cssVarMap ?= (sprite)->
        sprite.name = "#{name}-#{sprite.name}"
        sprite
      settings.cssOpts ?= {}
      if settings.cssFormat in ['scss','sass'] and not PROP.sprites.__mixinsAdded
        console.log 'sprites'
        settings.cssOpts.functions = true
        PROP.sprites.__mixinsAdded = true
      settings


  open: ->
    url: "http://" + open.host + ":" + open.port + open.path

  proxy: do ->
    mode = gutil.env.proxy or cfg.proxy.activeRemote
    unless cfg.proxy.remotes[mode]
      mode = _.keys(cfg.proxy.remotes)[0]
    port: cfg.proxy.port or 9001
    pushState: cfg.proxy.pushState or false
    pushStateIndex: "index.html"
    remotes: cfg.proxy.remotes[mode]
    remoteRoutes: cfg.proxy.remoteRoutes or []
    localRoutes: cfg.proxy.localRoutes or []

  path: {
    app: cfg.app or "app"
    clean: (prop=gutil.env.mode)->
      switch prop
        when "dist" then "dist"
        when "prod" then "prod"
        else ".tmp"
    build: (prop=gutil.env.mode)->
      switch prop
        when "dist" then "dist"
        when "prod" then "prod"
        else ".tmp"
    build_files: ->
      libpath.join PROP.path.build(), "**"

    scripts: (prop)->
      name = "main.js"
      switch prop
        when "main_base" then libpath.join PROP.path.app, "scripts"
        when "main_path" then libpath.join PROP.path.scripts("main_base"), name
        when "dest"   then libpath.join PROP.path.build(), "scripts"
        when ".dest"  then libpath.join PROP.path.build(), ".scripts"
        when "out"    then libpath.join PROP.path.scripts(".dest"), name
        when "result" then libpath.join PROP.path.scripts("dest"), name
        when "name"   then name
        when "extras_src" then [
          libpath.join PROP.path.app, "bower_components", "modernizr", "modernizr.js"
          libpath.join PROP.path.app, "bower_components", "requirejs", "require.js"
        ].concat(cfg.scripts)
        when "extras_dest" then libpath.join PROP.path.build(), "bower_components"
        else libpath.join PROP.path.app, "scripts", "**", "*.coffee"
    templates: (prop)->
      switch prop
        when "dest" then PROP.path.build()
        when "watch" then [
          PROP.path.templates(),
          libpath.join PROP.path.app, "scripts", "**", "*.jade"
        ]
        else libpath.join PROP.path.app, "html", "**", "*.jade"
    styles: (prop)->
      switch prop
        when "ext" then "sass"
        when "dest" then libpath.join PROP.path.build(), "styles"
        when "path" then libpath.join PROP.path.app, "bower_components"
        when "watch" then [
          libpath.join PROP.path.app, "styles", "**", "*.{sass,scss}"
          libpath.join PROP.path.app, "scripts", "**", "*.{sass,scss}"
          libpath.join PROP.path.app, "styles", "vendor.css"
        ]
        else [
          libpath.join PROP.path.app, "styles", "main.{sass,scss}"
          libpath.join PROP.path.app, "styles", "vendor.css"
        ]

    extras: (prop)->
      switch prop
        when "dest" then PROP.path.build()
        else [
          libpath.join PROP.path.app, "*.*"
          libpath.join PROP.path.app, "files", "**"
        ].concat( cfg.extras)

    fonts: (prop)->
      switch prop
        when "dest" then libpath.join PROP.path.build(), "styles", "fonts"
        when "pattern" then libpath.join "**", "*.{eot,svg,ttf,woff,woff2}"
        else libpath.join PROP.path.app, "styles", "fonts", PROP.path.fonts("pattern")


    images: (prop)->
      switch prop
        when "dest" then libpath.join PROP.path.build(), "images"
        when "jpg" then libpath.join PROP.path.build(), "images", "**", "*.{jpg,jpeg}"
        when "png" then libpath.join PROP.path.build(), "images", "**", "*.png"
        when "dest_src" then libpath.join PROP.path.build(), "images", "**", "*.{gif,png,jpg,jpeg,webp}"
        else libpath.join PROP.path.app, "images", "**", "*.{gif,png,jpg,jpeg,webp,svg}"

    images_preload:->
      if PROP.isDev
        PROP.path.images()
      else
        PROP.path.images("dest_src")

    sprites: (prop)->
      switch prop
        when "dest_images" then libpath.join PROP.path.build(), "images", "sprites"
        when "dest_styles" then libpath.join PROP.path.app, "styles"
        when "path" then libpath.join PROP.path.app, "images", "sprites"

    index: ->
      libpath.join PROP.path.build(), "index.html"

    livereload: ->
      build = PROP.path.build()
      [
        libpath.join build, "**/*.html"
        libpath.join build, "scripts", "**/*.js"
        libpath.join PROP.path.app, "images", "**/*"
      ]
  }

module.exports = PROP
