import MW from 'commons/skip_logic_constant';

export default (function () {
  const SELECT_ONE_TYPE = "Questions::SelectOne";
  const SELECT_MULTIPLE_TYPE = "Questions::SelectMultiple";

  return {
    init,
    initOptionsToCriteriaQuestionSelect,
  };

  function initOptionsToCriteriaQuestionSelect(criteriaWrapper) {
    assignOptionsToCriteriaQuestionSelect(criteriaWrapper);
    toggleCriteriaRelevant(criteriaWrapper);
  }

  function init() {
    if (typeof MW.Operator == 'function') {
      MW.Operator();
    };

    onChangeCriteriaQustionCode();
    onChangeOperator();
    onSubmitForm();

    let criteriaWrappers = $(".criteria");

    for (let i=0; i<criteriaWrappers.length; i++) {
      let criteriaWrapper = $(criteriaWrappers[i]);
      assignOptionsToCriteriaQuestionSelect(criteriaWrapper);
      initTagify($(criteriaWrapper));

      if (!!criteriaWrapper.find('.question-select').data('value')) {
        criteriaWrapper.find('.question-select').change();
      }
    }
  }

  function onSubmitForm() {
    $(document).on('submit', "form.skip-logic", function(){
       let doms = $(".criteria");

       for(let i=0; i<doms.length; i++) {
         let criteriaWrapper = $(doms[i]);
         var data = criteriaWrapper.find("tag").map((i, dom) => $(dom).attr('value')).toArray().join(',');
         criteriaWrapper.find('input.response_value').val(data);
       }
    });
  }

  // Options -------------------
  function getSelectedTypes() {
    let fieldTypes=$(".field-type");
    let types = [];

    for(var i=0; i<fieldTypes.length; i++) {
      if ([SELECT_ONE_TYPE, SELECT_MULTIPLE_TYPE].includes(fieldTypes[i].value)) {
        types.push(fieldTypes[i]);
      }
    }

    return types;
  }

  function buildOptions(criteriaWrapper, value) {
    let types = getSelectedTypes();
    let currentCode = criteriaWrapper.parents('.fieldset').find('.question-code').val();
    let options = [`<option value=''>${locale.select_question_from_list}</option>`];

    for(var i=0; i<types.length; i++) {
      let parent = $(types[i]).parents('.fieldset')
      let name = parent.find('.field-name').val();
      let questionCode = parent.find('.question-code').val();

      if (currentCode == questionCode) { break; }
      let isSelected = questionCode == value ? "selected" : "";
      options.push(`<option value='${questionCode}' ${isSelected}>${name}</option>`);
    }

    return options;
  }

  function assignOptionsToCriteriaQuestionSelect(criteriaWrapper) {
    let questionSelect = criteriaWrapper.find('.question-select');
    let options = buildOptions(criteriaWrapper, questionSelect.data('value'));

    $(questionSelect).html(options);
  }
  // Option end---------------------

  // Operator----------------
  function onChangeCriteriaQustionCode() {
    $(document).on('change', '.question-select', function (event) {
      assignOperator(event.currentTarget);
    });
  }

  function onChangeOperator() {
    $(document).on('change', '.operator-select', function (event) {
      initTagify($(event.currentTarget).parents('.criteria'));
    });
  }

  function assignOperator(questionSelect) {
    let questionCode = questionSelect.value;
    if(!questionCode) { return }

    let fieldType = $(`.question-code`).filter((i, o) => o.value == questionCode).parents('.fieldset').find('.field-type');
    let operatorDom = $(questionSelect).parents('.criteria').find('.operator-select');
    let opertorOptions = MW.Operator[fieldType.val()];
    let arr = [];

    for (let i=0; i<opertorOptions.length; i++) {
      let option = $(opertorOptions[i]);
      if (option.val() == operatorDom.data('value')) {
        option.attr("selected", true);
      }

      arr.push(option)
    }

    operatorDom.html(arr);
  }

  // Operator end------------

  function initTagify(criteriaWrapper) {
    // Remove tags
    criteriaWrapper.find('tags.response_value').remove();

    // Re init tagify
    let operator = criteriaWrapper.find('.operator-select').val();
    let tagOption = operator == MW.SkipLogicConstant.EQUAL_OPERATOR ? { maxTags: 1 } : {};
    let responseValueDom = criteriaWrapper.find('.response_value')[0];

    new Tagify(responseValueDom, tagOption);
  }

  function toggleCriteriaRelevant(criteriaWrapper) {
    let parent = criteriaWrapper.parents(".skip-logic-content");
    setTimeout(()=> {
      if (parent.find(".criteria:visible").length > 1) {
        parent.find('.relevant').removeClass('d-none');
      } else {
        parent.find('.relevant').addClass('d-none');
      }
    })
  }
})();
