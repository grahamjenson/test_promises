qhttp = require("q-io/http")
q = require('q')

Cachy = {
  _cache : {}

  write_cache: (key, data) -> @_cache[key] = data

  read_cache: (key) -> @_cache[key]

  reset_cache: -> @_cache = {}

  get: (url) ->
    if @_cache[url]  
      return q.fcall(=> @_cache[url])
    return qhttp.read(url).then( (buf) =>
      json = JSON.parse(buf)
      @write_cache(url,json); 
      return json
    )
}

if (typeof module != 'undefined' && module.exports)
    module.exports = Cachy;