express = require('express')
app = express()
{ search, getContent } = require './index'

app.use(express.static('./website'));

app.get '/search/:query', (req, res) ->

  { query } = req.params
  res.send search(query)
  return

app.get '/getContent/:query', (req, res) ->

  { query } = req.params
  res.send getContent(query)
  return

server = app.listen(8081, ->
  host = server.address().address
  port = server.address().port
  console.log 'Example app listening at http://%s:%s', host, port
  return
)