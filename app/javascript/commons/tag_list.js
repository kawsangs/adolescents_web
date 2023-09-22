import Tagify from "@yaireo/tagify";

export default (function() {
  return { initTagify, reassignValueWithComma };

  function initTagify(dom, params={}) {
    let input = $(dom);
    let tagify = new Tagify(input[0], getTagOptions(input, params.options));

    tagify.on('add', setValueToTagListInput);
    tagify.on('remove', setValueToTagListInput);

    function setValueToTagListInput(e) {
      let tagList = tagify.value.map((v,i) => v.value).join(',');

      !!params.callback && (typeof params.callback === 'function') && params.callback(input, tagList);
    }
  }

  function getTagOptions(input, options={}) {
    let option = {
      whitelist: input.data('tags'),
      dropdown: { maxItems: 20, classname: "tags-look", enabled: 0, closeOnSelect: false }
    }
    if (!!options) {
      option = {...option, ...options}
    }

    return option;
  }

  function reassignValueWithComma(input) {
    if (input.val().length) {
      let transformValue = JSON.parse(input.val()).map(x => x.value);
      input.val(`${transformValue.join(',')}`);
    }
  }
})();
