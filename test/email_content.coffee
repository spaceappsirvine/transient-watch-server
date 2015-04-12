assert = require 'assert'
{expect} = require 'chai'
fs = require 'fs'

EmailContent = require '../src/email_content.coffee'

describe 'EmailContent', ->
  emailContent = new EmailContent()
  data = [
    altName: "V821 Ara",
    days: "642",
    dec: "-48.7900",
    lastdays: "54131 ( 2993)",
    mean: "13",
    name: "GX 339-4",
    peak: "703",
    ra: "255.706",
    rank: "34",
    tenday: "-",
    today: "140 ( 5.0)",
    type: "LMXB/BH",
    yesterday: "40 ( 5.0)"
  ,
    altName: "V1055 Ori",
    days: "588",
    dec: "9.13700",
    lastdays: "53628 ( 3496)",
    mean: "21",
    name: "4U 0614+09",
    peak: "52",
    ra: "94.2800",
    rank: "35",
    tenday: "14 ( 7.6)",
    today: "-",
    type: "LMXB/NS",
    yesterday: "10 ( 2.0)"
  ]

  describe '.getSubject(date)', ->
    it 'should not be have the correct subject', ->
      expect(emailContent.getSubject('4/12/2014')).to.equal "Updates for 4/12/2014"


  describe '.getBodyWithData(data)', ->
    it 'should genrate the correct body', (done) ->
      expect(emailContent.getBodyWithData(data, 50)).to.not.equal ""
      done()
