import Typeahead from "typeahead";

export default (function() {
  return { initTypeahead };

  function initTypeahead(dom, collection) {
    let self = this;

    new Typeahead(dom, {
      hint: true,
      highlight: true,
      minLength: 1,
      source: substringMatcher(collection)
    })
  }

  function substringMatcher(strs) {
    return function findMatches(q, cb) {
      var matches, substringRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      let substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push(str);
        }
      });

      cb(matches);
    };
  };
})();
