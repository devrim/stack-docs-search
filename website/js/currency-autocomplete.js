requirejs.config({
    baseUrl: 'js/',
    paths: {
        jquery: 'jquery-1.9.1.min',
        autocomplete: 'jquery.autocomplete.min',
        marked: 'marked.min'
    },
    shim:{
      autocomplete: {
        deps : ["jquery"],
        exports: "jquery.autocomplete"
      }
    }
});

// var marked = require('marked');

requirejs(['jquery',"autocomplete","marked"], function( $,autocomplete,marked ) {

    // var marked = require("marked")

    $.getJSON('/docs.json',function(docs){
        $('#autocomplete').autocomplete({
          lookup: docs,
          minLength: 0,
          onSelect: function (suggestion) {
            var thehtml = marked(suggestion.data)
            $('#outputcontent').html(thehtml);
          }
        });
    });

  // });
});
