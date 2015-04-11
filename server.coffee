ApiServer = require './src/api_server'
DataServer = require './src/data_server'

apiPort = process.env.SERVE_PORT or 8000
dataSource = process.env.SOURCE or 'http://swift.gsfc.nasa.gov/results/transients/BAT_current.html'

type = process.argv[2]
if type? and type in ['api', 'data']
  switch type
    when 'api' then server = new ApiServer apiPort
    when 'data' then server = new DataServer dataSource
    else throw new Error 'Please specify `api`, `data` for server type.'

server.start()
