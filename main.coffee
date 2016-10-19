express = require('express')
app = express()

app.use(express.static('./website'));

# app.get '/', (req, res) ->
#   res.send fs.readFileSync "./index.html"
#   return
server = app.listen(8081, ->
  host = server.address().address
  port = server.address().port
  console.log 'Example app listening at http://%s:%s', host, port
  return
)