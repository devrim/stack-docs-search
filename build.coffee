recursive = require 'recursive-readdir'
fs = require 'fs'
marked = require 'marked'
_ = require "underscore"
hcl2json = require "hcl-to-json"
child_process = require('child_process')
json2yml = require('json2yaml')
fuzzy = require "fuzzy"

replaceHclToYaml = (title,str)->
  
  # check for ...'s
  str = str.split("...").join("# ...")


  a = str.split("```")
  a.forEach (v,k) ->
    if k%2 is 1
      try
        a[k] = json2yml.stringify hcl2json v
        
      catch err
        console.log title,v
  return a.join("```")


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
          content.push {value:title,path:path,data:replaceHclToYaml(title,data),marked:marked(data)}
      fs.writeFileSync "./website/docs.json",JSON.stringify(content,null,"\t")
      fs.writeFileSync "./docs.json",JSON.stringify(content,null,"\t")
      # child_process.execSync "rm -rf ./terraform;"
      callback null

docs = JSON.parse fs.readFileSync("./website/docs.json")
searchDocs = (query)->
  results = []
  docs.forEach (content)->
    if content.data.indexOf(query) > 0
      results.push [content.path]
  return results

search = (query)->
  options =
    pre: '<'
    post: '>'
    extract: (el) -> return el.value

  results = fuzzy.filter(query, docs, options);
  matches = results.map((el)-> el.string)
  return matches
    #console.log args


# recreateDocs ->
#   console.log "done."

module.exports = {recreateDocs,searchDocs,search}


