recursive = require 'recursive-readdir'
fs = require 'fs'
marked = require 'marked'
_ = require "underscore"
child_process = require('child_process')


recreateDocs = (callback)  ->
  fs.stat "/terraform",(err,res)->
    if err
      child_process.execSync "git clone https://github.com/hashicorp/terraform/ --depth 1; rm -rf ./terraform/.git"
    recursive 'terraform/website/source/docs', (err, files)->
      content =[]
      files.forEach (path,k)->  
        data = fs.readFileSync path,'utf-8'
        if path.indexOf(".md") > 0 or path.indexOf(".markdown") > 0
          title = data.substring(data.indexOf('page_title:')+13,data.indexOf('sidebar_current:')-2)
          content.push {value:title,path:path,data:data,marked:marked(data)}
      fs.writeFileSync "./website/docs.json",JSON.stringify(content,null,"\t")
      # child_process.execSync "rm -rf ./terraform;"
      callback null

searchDocs = (query)->
  results = []
  docs = JSON.parse fs.readFileSync("./website/docs.json")
  docs.forEach (content)->
    if content.data.indexOf(query) > 0
      results.push [content.path]
  return results
    #console.log args



recreateDocs ->
  console.log "done."





