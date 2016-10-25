var child_process, docs, fs, fuzzy, hcl2json, json2yml, marked, recreateDocs, recursive, replaceHclToYaml, search, searchDocs;

recursive = require('recursive-readdir');

fs = require('fs');

marked = require('marked');

hcl2json = require("hcl-to-json");

child_process = require('child_process');

json2yml = require('json2yaml');

fuzzy = require("fuzzy");

replaceHclToYaml = function(title, str) {
  var a;
  str = str.split("...").join("# ...");
  a = str.split("```");
  a.forEach(function(v, k) {
    var err;
    if (k % 2 === 1) {
      try {
        return a[k] = json2yml.stringify(hcl2json(v));
      } catch (_error) {
        err = _error;
        return console.log(title, v);
      }
    }
  });
  return a.join("```");
};

recreateDocs = function(callback) {
  return fs.stat("/terraform", function(err, res) {
    if (err) {
      child_process.execSync("git clone https://github.com/hashicorp/terraform/ --depth 1; rm -rf ./terraform/.git");
    }
    return recursive('terraform/website/source/docs', function(err, files) {
      var content;
      content = [];
      files.forEach(function(path, k) {
        var data, title;
        data = fs.readFileSync(path, 'utf-8');
        if (path.indexOf(".md") > 0 || path.indexOf(".markdown") > 0) {
          title = data.substring(data.indexOf('page_title:') + 13, data.indexOf('sidebar_current:') - 2);
          return content.push({
            value: title,
            path: path,
            data: replaceHclToYaml(title, data),
            marked: marked(data)
          });
        }
      });
      fs.writeFileSync("./website/docs.json", JSON.stringify(content, null, "\t"));
      fs.writeFileSync("./docs.json", JSON.stringify(content, null, "\t"));
      return callback(null);
    });
  });
};

docs = JSON.parse(fs.readFileSync("./docs.json"));



searchDocs = function(query) {
  var results;
  results = [];
  docs.forEach(function(content) {
    if (content.data.indexOf(query) > 0) {
      return results.push([content.path]);
    }
  });
  return results;
};

getContent = function(title){
  docs.forEach(function(v) {
    if (content.title == title) {
      return content.data
    }
  });
  return null

}

search = function(query) {
  var matches, options, results;
  options = {
    pre: '',
    post: '',
    extract: function(el) {
      return el.value;
    }
  };
  results = fuzzy.filter(query, docs, options);
  matches = results.map(function(el) {
    final = []
    return({title:el.string,content_markdown:el.original.data})
  });
  return matches;
};

module.exports = {
  recreateDocs: recreateDocs,
  searchDocs: searchDocs,
  search: search
};