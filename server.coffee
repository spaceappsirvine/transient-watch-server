ApiServer = require './src/api_server'
DataServer = require './src/data_server'

apiPort = process.env.SERVE_PORT or 8000
new ApiServer(apiPort).start()
