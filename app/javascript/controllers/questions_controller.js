import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "btnAddName", "btnAddOption", "btnRemoveQuestion", "btnCollapseTrigger" ]

  showChooseDataType(event) {
    let dom = $(this.btnAddNameTarget)
    let parent = dom.parents('.fieldset');

    dom.hide();
    parent.find('.field-type-wrapper').show();
    parent.find('.field-name').addClass('no-style');
  }

  renderTitleStyle(event) {
    let dom = $(event.target);
    let fieldType = event.params.fieldType;

    this._setFieldNameInputAsTitleStyle(dom);
    this._assignBtnMove(dom);
    this._assignFieldType(dom, fieldType);
    this._handleCollapseContent(dom, fieldType);
  }

  _setFieldNameInputAsTitleStyle(dom) {
    dom.parents('.fieldset').find('.field-name').addClass('as-title');
  }

  _assignBtnMove(dom) {
    let btnMove = dom.parents('.fieldset').find('.move');
    btnMove.empty();
    btnMove.append($(dom.find('.icon')).clone());
    btnMove.show();
  }

  _assignFieldType(dom, fieldType) {
    dom.parents('.fieldset').find('.field-type').val(fieldType);
  }

  _handleCollapseContent(dom, field_type) {
    if (field_type == 'Questions::SelectOne') {
      this._showOption(dom);
      this.appendOptionField();
      this._showArrowDownIcon(dom);
    }

    if (field_type == 'Questions::Faq') {
      this._showFaqAnswer(dom);
      this._showArrowDownIcon(dom);
    }

    this._hideFieldTypeList(dom);
  }

  _showFaqAnswer(dom) {
    dom.parents('.fieldset').find('.faq-wrapper').show();
  }

  _showOption(dom) {
    dom.parents('.fieldset').find('.options-wrapper').show();
  }

  _showArrowDownIcon(dom) {
    let icon = dom.parents('.fieldset').find('.collapse-trigger i');

    icon.removeClass('fa-caret-right').addClass('fa-caret-down');
    dom.parents('.fieldset').find('.collapse-trigger').show();
  }

  _hideFieldTypeList(dom) {
    dom.parents('.fieldset').find('.field-type-wrapper').hide();
  }

  appendOptionField(event=null) {
    !!event && event.preventDefault();

    let dom = $(this.btnAddOptionTarget);
    let time = new Date().getTime();
    let regexp = new RegExp(dom.data('id'), 'g');
    let field = $(dom.data('fields').replace(regexp, time));

    dom.before(field);
  }

  removeQuestion(event) {
    event.preventDefault();
    let dom = $(this.btnRemoveQuestionTarget);

    dom.parent().find('input[type=hidden]').val('1');
    dom.closest('fieldset').hide();
  }

  toggleCollapseContent(event) {
    let dom = $(event.target);
    let content = dom.parents('.fieldset').find('.collapse-content');
    let icon = $(dom.find('i'));

    content.toggle();

    if ($(content).is(":visible")) {
      icon.removeClass('fa-caret-right');
      icon.addClass('fa-caret-down');
    } else {
      icon.addClass('fa-caret-right');
      icon.removeClass('fa-caret-down');
    }
  }
}
