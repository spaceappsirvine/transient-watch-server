cheerio = require 'cheerio'
http = require 'http'
redis = require 'redis'
{parse} = require 'url'
EmailContent = require './email_content'
EmailService = require './email_service'

TIMEOUT = 5000 # 5 Second Timeout
INTERVAL = 60 * 5 * 1000 # 5 Minutes
ONE_DAY = 24 * 60 * 60 * 1000 # 1 Day
KEY_EVENT = 'events'

class DataServer

  constructor: (@source, @testing = false) ->
    console.log 'Data Server Constructed'
    @emailContent = new EmailContent()
    @emailService = new EmailService()
    @lastSent = Date.now()

  start: ->
    console.log 'Data Server Started'
    @tick (->), true

    # Run Every 5 Minutes
    setInterval ->
      console.log 'Worker Executing....'
      @tick (->), true
    , INTERVAL


  tick: (onSuccess = (->), refresh = false) ->
    console.log 'Data Server Tick'
    @_initRedis()
    if refresh
      @loadFromSource onSuccess
    else
      @loadFromCache onSuccess


  loadFromCache: (onSuccess) ->
    @redis.get KEY_EVENT, (err, result) =>
      if err? or not result
        @loadFromSource onSuccess
      else
        onSuccess JSON.parse result


  loadFromSource: (onSuccess) ->
    {port, hostname, pathname} = parse @source
    options =
      hostname: hostname
      port: port
      path: pathname
      method: 'GET'

    req = http.request options, (res) =>
      data = ''
      res.on 'data', (chunk) -> data += chunk
      res.on 'end', => onSuccess @process data
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
        if cellIndex is 2
          value = cell.find('a').first().text().replace /\ +(?= )/g, ''
        else
          value = cell.html()
        cellData[@_propertyForIndex cellIndex] = if value? then value.trim() else ''
        cell = cell.next()
      structures.push cellData if cellData.name

    unless @testing
      @redis.set KEY_EVENT, JSON.stringify structures
      @mailUsers(structures)
      @redis.quit()

    structures


  mailUsers: (data) ->
    if Date.now() - @lastSent > ONE_DAY
      @lastSent = Date.now()
      @redis.get 'emails', (result) ->
        emails = JSON.parse result
        subject = @emailContent.getSubject @emailService.getDateString()
        body = @emailContent.getBodyWithData data
        for user in emails
          @emailService.send user.email, subject, body


  _propertyForIndex: (index) ->
    switch index
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



  _initRedis: ->
    {port, hostname, auth} = parse process.env.REDISTOGO_URL
    @redis = redis.createClient port, hostname
    @redis.auth auth.split(":")[1]


module.exports = DataServer
