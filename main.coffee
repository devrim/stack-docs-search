express = require('express')
app = express()
search = require("./index").search

app.use(express.static('./website'));

app.get '/search/:query', (req, res) ->
  console.log req.params
  res.send search(req.params.query)
  return

server = app.listen(8081, ->
  host = server.address().address
  port = server.address().port
  console.log 'Example app listening at http://%s:%s', host, port
  return
)