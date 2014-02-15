chai = require 'chai'

should = chai.should()
expect = chai.expect
assert = chai.assert

sinon = require 'sinon'

Testy = require '../testy'

qhttp = Testy.qhttp
q = require 'q'

describe 'Testy.get', ->
  describe 'if the data is cached', ->
    it 'should get the data from cache if it has it',  (done) ->
      url = 'http://www.maori.geek.nz' 

      Testy.write_cache(url, {name: 'maori.geek'})
      Testy.get(url).then( (data) ->
        data.name.should.equal 'maori.geek'
        done()
      )
      .catch((error) ->
        done(error)
      )
      .fin( -> 
        Testy.reset_cache()
      )

  describe 'if the data is not cached', ->
    it 'should call qhttp to read the data, and cache it', (done) ->
      url = 'http://www.maori.geek.nz' 
      data = {name: 'maori.geek'}

      sinon.stub(qhttp, 'read', (url) -> 
        url.should.equal url
        return q.fcall(-> new Buffer( JSON.stringify(data) ))
      )
      Testy.get(url).then( (data) ->
        data.name.should.equal 'maori.geek'
        Testy.read_cache(url).should.equal data
        done()
      )
      .catch( (error) ->
        done(error)
      )
      .fin( (value) ->
        Testy.reset_cache()
        qhttp.read.restore()
      )

