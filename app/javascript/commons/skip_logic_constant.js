var MW = {}

MW.SkipLogicConstant = {
  EQUAL_OPERATOR: '=',
  NOT_OPERATOR: '!=',
  MATCH_ANY_OPERATOR: 'in',
  MATCH_ALL_OPERATOR: 'match_all'
};

MW.Operator = function() {
  function selectOne() {
    return [
      generateOptionDom(locale.please_select, ''),
      generateOptionDom('(=)', MW.SkipLogicConstant.EQUAL_OPERATOR),
      generateOptionDom(locale.any_of, MW.SkipLogicConstant.MATCH_ANY_OPERATOR),
      generateOptionDom("".concat(locale.skip_logic_not, " (!=)"), MW.SkipLogicConstant.NOT_OPERATOR)
    ];

  }

  function selectMultiple() {
    return [
      generateOptionDom(locale.please_select, ''),
      generateOptionDom('(=)', MW.SkipLogicConstant.EQUAL_OPERATOR),
      generateOptionDom(locale.any_of, MW.SkipLogicConstant.MATCH_ANY_OPERATOR),
      generateOptionDom(locale.match_all_of, MW.SkipLogicConstant.MATCH_ALL_OPERATOR),
      generateOptionDom("".concat(locale.skip_logic_not, " (!=)"), MW.SkipLogicConstant.NOT_OPERATOR)
    ];
  }

  function generateOptionDom(name, value) {
    return `<option value='${value}'>${name}</option>`;
  }

  MW.Operator = {
    "Questions::SelectOne": selectOne(),
    "Questions::SelectMultiple": selectMultiple()
  }
}

export default MW;
