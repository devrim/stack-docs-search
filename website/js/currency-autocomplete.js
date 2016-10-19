$(function(){
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

});