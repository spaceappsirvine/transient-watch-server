DataServer = require './data_server.coffee'
bodyParser = require 'body-parser'
express = require 'express'
fs = require 'fs'
redis = require 'redis'
{parse} = require 'url'
KEY_EMAILS = 'emails'

class ApiServer

  constructor: (@port) ->
    @app = express()
    @_constructRoutes()
    @_initRedis()


  start: ->
    @server = @app.listen @port, ->
      console.log 'Server is now running.'


  events: (request, response) =>
    @_eventData (data) ->
      response.set 'Content-Type', 'application/json'
      response.send
        status: 'success'
        count: data.length
        data: data


  register: (request, response) =>
    {email} = request.body
    @_initRedis()
    @redis.get KEY_EMAILS, (err, result) =>
      if err
        response.set 'Content-Type', 'application/json'
        response.send status: 'error', code: 500, message: 'Redis Unavailable'
        @redis.quit()
      else
        result ?= '[]'
        emails = JSON.parse result
        emails.push {email, lastSent: Date.now()}
        @redis.set KEY_EMAILS, JSON.stringify(emails), ->
          response.set 'Content-Type', 'application/json'
          response.send
            status: 'success'
          @redis.quit()


  root: (request, response) ->
    response.send 'Sorry Not a valid endpoint.'


  map: (request, response) ->
    fs.readFile 'public/map.html', (err, data) ->
      throw err if err?
      response.set 'Content-Type', 'text/html'
      response.send data


  _constructRoutes: ->
    # Additional Configuration:
    @app.use bodyParser.json()
    @app.use bodyParser.urlencoded extended: true

    @app.get '/', @root
    @app.get '/events', @events
    @app.get '/map', @map
    @app.post '/register', @register


  _eventData: (callback) ->
    server = new DataServer 'http://swift.gsfc.nasa.gov/results/transients/BAT_current.html'
    server.tick callback


  _initRedis: ->
    {port, hostname, auth} = parse process.env.REDISTOGO_URL
    @redis = redis.createClient port, hostname
    @redis.auth auth.split(":")[1]


module.exports = ApiServer
