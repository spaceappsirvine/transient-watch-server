express = require 'express'
fs = require 'fs'
DataServer = require './data_server.coffee'


class ApiServer

  constructor: (@port) ->
    @app = express()
    @_constructRoutes()


  start: ->
    @server = @app.listen @port, ->
      console.log 'Server is now running.'


  events: (request, response) =>
    @_eventData (data) ->
      response.set 'Content-Type', 'application/json'
      response.send
        status: 'success'
        data: data


  register: (request, response) ->
    response.set 'Content-Type', 'text/html'
    response.send
      status: 'success'


  root: (request, response) ->
    response.send 'Sorry Not a valid endpoint.'


  map: (request, response) ->
    fs.readFile 'public/map.html', (err, data) ->
      throw err if err?
      response.set 'Content-Type', 'text/html'
      response.send data

  _constructRoutes: ->
    @app.get '/', @root
    @app.get '/events', @events
    @app.post '/register', @register
    @app.get '/map', @map


  _eventData: (callback) ->
    server = new DataServer 'http://swift.gsfc.nasa.gov/results/transients/BAT_current.html'
    server.tick callback



module.exports = ApiServer
