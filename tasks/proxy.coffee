http = require 'http'
httpProxy = require 'http-proxy'
PROP = require '../lib/config'
_ = require "lodash"
RSVP = require 'rsvp'

options = do ->
  options = PROP.proxy || {} # options()
  options.remotes = options.remotes() if _.isFunction options.remotes
  options.remoteRoutes = options.remoteRoutes() if _.isFunction options.remoteRoutes
  options.localRoutes = options.localRoutes() if _.isFunction options.localRoutes

  options.local =
    host: "localhost"
    port: PROP.browserSync.port
  options

checkByRoutes = (req, res, routes)->
  promise = new RSVP.Promise (resolve, reject)->
    checked = false
    for r in routes when r.test req.url
      checked = true
      break
    resolve checked
  promise

checkLazy = (req, res, server)->
  reqOptions =
    hostname: options.local.host
    port: options.local.port
    path: req.url
    method: 'HEAD'
  promise = new RSVP.Promise (resolve, reject)->
    checkRequest = http.request reqOptions, (checkResponce) =>
      local = (checkResponce.statusCode == 404 and options.remotes.active)
      resolve local
    checkRequest.on 'socket', (socket)->
      socket.setTimeout 200
      socket.on 'timeout', -> checkRequest.abort()
    checkRequest.end()
    checkRequest.on 'error', (error, code)->
      gutil.log "#{error.code} #{error}"
  promise

createProxyServer = ->
  proxy = new httpProxy.createProxyServer()
  proxy.on 'error', (err, req, res) ->
    gutil.log gutil.colors.red err, "on url", gutil.colors.red req.url
    res.end()
  proxy

class Server
  constructor: ()->
    @server = http.createServer @onRequest
    @proxy = createProxyServer()

  listen: -> @server.listen(PROP.proxy.port)

  proxyRemote: (req, res)-> @proxyRequest req, res, false

  proxyLocal: (req, res)-> @proxyRequest req, res, true

  proxyRequest: (req , res, local)->
    proxyOptions = {changeOrigin: true}
    settings = if local then options.local else options.remotes
    proxyOptions.target = do ->
      protocol = if settings.https then "https" else "http"
      "#{protocol}://#{settings.host}:#{settings.port}"
    @proxy.web req, res, proxyOptions

  proxyLocalPushState: (req, res)->
    checkByRoutes req, res, options.localRoutes
    .then (isResource)=>
      req.url = options.pushStateIndex unless isResource
      @proxyLocal req, res

  onRequest: (req, res)=>
    checkByRoutes req, res, options.remoteRoutes
    .then (isRemote)=>
      if isRemote
        @proxyRemote req, res
      else
        if options.pushState
          @proxyLocalPushState req, res
        else
          @proxyLocal req, res
    return null


module.exports = ->
  server = new Server
  server.listen()
