express = require 'express'

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
    response.send 'serving a map'


  _constructRoutes: ->
    @app.get '/', @root
    @app.get '/map', @map

module.exports = ApiServer
