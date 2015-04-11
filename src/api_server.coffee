express = require 'express'
fs = require 'fs'


class ApiServer

  constructor: (@port) ->
    @app = express()
    @_constructRoutes()


  start: ->
    @server = @app.listen @port, ->
      console.log 'Server is now running.'


  root: (request, response) ->
    response.send 'Sorry Not a valid endpoint.'


  map: (request, response) ->
    fs.readFile 'public/map.html', (err, data) ->
      throw err if (err)
      response.set('Content-Type', 'text/html')
      response.send(data)

  _constructRoutes: ->
    @app.get '/', @root
    @app.get '/map', @map


module.exports = ApiServer
