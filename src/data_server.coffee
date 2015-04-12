cheerio = require 'cheerio'
http = require 'http'
redis = require 'redis'
{parse} = require 'url'

TIMEOUT = 5000 # 5 Second Timeout
INTERVAL = 60 * 60 * 1000 # Hourly
KEY_EVENT = 'events'

class DataServer

  constructor: (@source) ->
    @_initRedis()


  start: ->
    @tick (->), true
    # setInterval (=> @tick (->), true), INTERVAL


  tick: (callback = (->), refresh = false) ->
    if refresh
      @loadFromSource callback
    else
      @loadFromCache callback


  loadFromCache: (callback) ->
    @redis.get KEY_EVENT, (err, result) =>
      if err? or not result
        @loadFromSource callback
      else
        callback JSON.parse result


  loadFromSource: (callback) ->
    {port, hostname, pathname} = parse @source
    options =
      hostname: hostname
      port: port
      path: pathname
      method: 'GET'

    req = http.request options, (res) =>
      data = ''
      res.on 'data', (chunk) -> data += chunk
      res.on 'end', => callback @process data
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
          value = cell.find('a').text().replace /\ +(?= )/g, ''
        else
          value = cell.html()
        cellData[propertyName] = value.trim()
        cell = cell.next()
        structures.push cellData
    @redis.set KEY_EVENT, JSON.stringify structures
    structures


  _initRedis: ->
    {port, hostname, auth} = parse process.env.REDISTOGO_URL
    @redis = redis.createClient port, hostname
    @redis.auth auth.split(":")[1]


module.exports = DataServer
