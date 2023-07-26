import Tagify from "@yaireo/tagify";

export default (function() {
  return { initTagify, reassignValueWithComma };

  function initTagify(input) {
    new Tagify(input, {
      whitelist: $(input).data('tags'),
      dropdown: { maxItems: 20, classname: "tags-look", enabled: 0, closeOnSelect: false }
    });
  }

  function reassignValueWithComma(input) {
    if (input.val().length) {
      let transformValue = JSON.parse(input.val()).map(x => x.value);
      input.val(`${transformValue.join(',')}`);
    }
  }
})();
