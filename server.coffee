ApiServer = require 'src/api_server'
DataServer = require 'src/data_server'

providedArgument = process.argv[0]
unless providedArgument? or providedArgument not in ['api', 'data']
  throw Error '''Please Specify the Type of Server to start with 'api' or 'data' '''

switch providedArgument
  when 'api' then server = new ApiServer()
  else server = new DataServer()
