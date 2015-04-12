DataServer = require './data_server.coffee'
bodyParser = require 'body-parser'
express = require 'express'
fs = require 'fs'
http = require 'http'
redis = require 'redis'
{parse} = require 'url'
webshot = require 'webshot'
KEY_EMAILS = 'emails'

class ApiServer

  constructor: (@port, @redis) ->
    @app = express()
    @_constructRoutes()


  start: ->
    @server = @app.listen @port, ->
      console.log 'Server is now running.'


  bookmark: (request, response) =>
    {uuid, name} = request.body
    console.log uuid
    console.log name
    @redis.get uuid, (err, result) =>
      result ?= '[]'
      favorites = JSON.parse result
      favorites.push {name}
      @redis.set uuid, JSON.stringify(favorites), =>
        response.send
          status: 'success'


  bookmarks: (request, response) =>
    {uuid} = request.query
    @redis.get uuid, (err, result) =>
      result = JSON.parse(result or '[]')
      @_eventData (data) =>
        final = []
        for item in result
          for event in data when item.name is event.name
            final.push event

        response.send
          status: 'success'
          data: @removeDuplicates final


  removeDuplicates: (ar) ->
    if ar.length == 0
      return []
    res = {}
    for o in ar
      res[o.name] = o
    value for _, value of res


  events: (request, response) =>
    @_eventData (data) ->
      response.set 'Content-Type', 'application/json'
      response.send
        status: 'success'
        count: data.length
        data: data


  register: (request, response) =>
    {email} = request.body
    @redis.get KEY_EMAILS, (err, result) =>
      if err
        response.set 'Content-Type', 'application/json'
        response.send status: 'error', code: 500, message: 'Redis Unavailable'
      else
        result ?= '[]'
        emails = JSON.parse result
        emails.push {email, lastSent: Date.now()}
        @redis.set KEY_EMAILS, JSON.stringify(emails), =>
          response.set 'Content-Type', 'application/json'
          response.send
            status: 'success'


  root: (request, response) ->
    response.send 'Sorry Not a valid endpoint.'


  map: (request, response) ->
    fs.readFile 'public/map.html', (err, data) ->
      response.set 'Content-Type', 'text/html'
      response.send data


  preview: (request, response) ->
    name = "preview-#{request.query['location']}.png"
    fs.exists name, (exists) ->
      if exists
        response.download name
      else
        url = "http://galactic-titans.herokuapp.com/map?location=#{request.query['location']}"
        options =
          renderDelay: 3000
          windowSize:
            width: 800
            height: 700
          shotSize:
            width: 500
            height: 500
          shotOffset:
            left: 150
            top: 100
        webshot url, name, options, (err) ->
          unless err?
            response.download name


  _constructRoutes: ->
    @app.use bodyParser.json()
    @app.use bodyParser.urlencoded extended: true

    @app.get '/', @root
    @app.get '/events', @events
    @app.get '/map', @map
    @app.get '/preview', @preview
    @app.get '/bookmarks', @bookmarks
    @app.post '/register', @register
    @app.post '/bookmark', @bookmark


  _eventData: (onSuccess) ->
    server = new DataServer 'http://swift.gsfc.nasa.gov/results/transients/BAT_current.html', @redis
    server.tick onSuccess

module.exports = ApiServer
