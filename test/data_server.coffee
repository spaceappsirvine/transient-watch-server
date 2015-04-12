assert = require 'assert'
{expect} = require 'chai'
fs = require 'fs'

DataServer = require '../src/data_server'

describe 'DataServer', ->
  htmlSource = ''
  dataServer = null
  structures = []

  before (done) ->
    htmlSource = fs.readFileSync 'test/source.html', encoding: 'utf8'
    dataServer = new DataServer('', true)
    structures = dataServer.process htmlSource
    done()


  describe 'html string for tests', ->
    it 'should not be empty', ->
      expect(htmlSource).to.not.equal undefined
      expect(htmlSource).to.not.equal ''


  describe '.process', ->
    it 'should have DataServer instance', (done) ->
      expect(dataServer).to.not.equal null
      done()

    it 'should should return a non-zero length', (done) ->
      expect(structures.length).to.equal 35
      done()

    it 'should have the correct fields', (done) ->
      event = structures[0]
      expect(event.rank).to.equal '1'
      expect(event.name).to.equal 'Sco X-1'
      expect(event.ra).to.equal '244.979'
      expect(event.dec).to.equal '-15.6400'
      expect(event.altName).to.equal 'V818 Sco'
      expect(event.type).to.equal 'LMXB/NS'
      expect(event.today).to.equal '1331 (25.0)'
      expect(event.yesterday).to.equal '1150 (27.6)'
      expect(event.tenday).to.equal '-'
      expect(event.mean).to.equal '475'
      expect(event.peak).to.equal '3353'
      expect(event.days).to.equal '3270'
      expect(event.lastdays).to.equal '53544 ( 3580)'
      done()

