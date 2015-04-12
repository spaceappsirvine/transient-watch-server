ApiServer = require './src/api_server'
DataServer = require './src/data_server'
{parse} = require 'url'
redis = require 'redis'
apiPort = process.env.PORT or 8000
dataSource = process.env.SOURCE or 'http://swift.gsfc.nasa.gov/results/transients/BAT_current.html'
type = process.argv[2]

if type? and type in ['api', 'data']
  {port, hostname, auth} = parse process.env.REDISTOGO_URL
  client = redis.createClient port, hostname
  client.auth auth.split(':')[1]
  switch type
    when 'api' then server = new ApiServer apiPort, client
    when 'data' then server = new DataServer dataSource, client

throw new Error 'Please specify `api`, `data` for server type.' unless server

server.start()
