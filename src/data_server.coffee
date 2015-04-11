cheerio = require 'cheerio'
http = require 'http'
{parse} = require 'url'
{usleep} = require 'sleep'

TIMEOUT = 5000 # 5 Second Timeout
INTERVAL = 60 * 60 * 1000 # Hourly

class DataServer

  constructor: (@source) ->


  start: ->
    @tick()
#    setInterval (=> @tick), 20000 # INTERVAL


  tick: ->
    {port, hostname, pathname} = parse @source
    options =
      hostname: hostname
      port: port
      path: pathname
      method: 'GET'

    req = http.request options, (res) =>
      data = ''
      res.on 'data', (chunk) -> data += chunk
      res.on 'end', => @process data
    req.end()

  process: (data) ->
    $ = cheerio.load data
    rows = $ 'table tr'
    structures = []
    for index in [1..70]
      rows = rows.next()
      cell = rows.find('td')
      cellData = {}
      for cellIndex in [1..13]
        propertyName = switch cellIndex
          when 1 then 'rank'
          when 2 then 'name'
          when 3 then 'ra'
          when 4 then 'dec'
          when 5 then 'altName'
          when 6 then 'type'
          when 7 then 'today'
          when 8 then 'yesterday'
          when 9 then 'tenday'
          when 10 then 'mean'
          when 11 then 'peak'
          when 12 then 'days'
          when 13 then 'lastdays'
        if cellIndex is 2
          value = cell.find('a').text()
        else
          value = cell.html()
        cellData[propertyName] = value.trim()
        cell = cell.next()
        structures.push cellData
    structures

module.exports = DataServer
