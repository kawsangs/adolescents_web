import { Controller } from "@hotwired/stimulus";
import jquerySortable from 'libs/jquerySortable';
import tagList from 'commons/tag_list';

export default class extends Controller {
  static targets = [ "btnAddQuestion", "btnCollapseAllTrigger", "tagList" ]

  connect() {
    this._initQuestionView();
    this._initSortable();
    tagList.initTagify(this.tagListTarget);
  }

  _initSortable() {
    let self = this;
    $(document).find('ol.fields.sortable').sortable({
      handle: '.move',
      onDrop: ($item, container, _super) => {
        self._animateListItems($item, container, _super)
        self._assignDisplayOrderToListItem()
      }
    })
  }

  _assignDisplayOrderToListItem() {
    $('ol.fields li').each((index, dom) => {
      $(dom).find('.display-order').val(index)
    })
  }

  _animateListItems($item, container, _super) {
    let $clonedItem = $('<li/>').css({height: 0})
    $item.before($clonedItem)
    $clonedItem.animate({'height': $item.height()})
    $item.animate($clonedItem.position(), () => {
      $clonedItem.detach()
      _super($item, container)
    })

    return
  }

  _initQuestionView() {
    $('input.field-type').each((index, dom) => {
      if (dom.value) {
        this._initBtnMove(dom);
        this._initFieldNameStyleAsTitle(dom);
        this._initCollapseContent(dom);
      }
    })
  }

  _initBtnMove(dom) {
    let parentDom = $(dom).parents('.fieldset')
    let icon = parentDom.find("[data-field_type='" + dom.value + "'] .icon").clone()
    let btnMove = parentDom.find('.move')
    btnMove.empty()
    btnMove.append(icon)
    btnMove.show()
  }

  _initFieldNameStyleAsTitle(dom) {
    let parentDom = $(dom).parents('.fieldset');
    parentDom.find('.field-name').addClass('no-style as-title');
    parentDom.find('.btn-add-field').hide();
  }

  _initCollapseContent(dom) {
    this._hideCollapseContent(dom);

    if (dom.value == "Questions::SelectOne") {
      this._showCollapseTrigger(dom);
      this._showOption(dom);
    } else if (dom.value == "Questions::Faq") {
      this._showCollapseTrigger(dom);
      this._showFaqAnswer(dom);
    }
  }

  _showFaqAnswer(dom) {
    $(dom).parents('.fieldset').find('.faq-wrapper').show();
  }

  _showOption(dom) {
    $(dom).parents('.fieldset').find('.options-wrapper').show()
  }

  _hideCollapseContent(dom) {
    $(dom).parents('.fieldset').find('.collapse-content').hide()
  }

  _showCollapseTrigger(dom) {
    $(dom).parents('.fieldset').find('.collapse-trigger').show()
  }

  submitForm(e) {
    tagList.reassignValueWithComma($(this.tagListTarget));
  }

  appendField(event) {
    event.preventDefault();

    let dom = $(this.btnAddQuestionTarget);
    let time = new Date().getTime();
    let regexp = new RegExp(dom.data('id'), 'g');
    let field = $(dom.data('fields').replace(regexp, time));

    dom.before(field);
  }

  toggleCollapseAllContent(event) {
    let dom = $(this.btnCollapseAllTriggerTarget);
    let content = $('.fieldset').find('.collapse-content');
    let icon = $(dom.find('i'));
    let icons = $(".collapse-trigger").find('i');

    content.toggle();

    if ($(content).is(":visible")) {
      icon.removeClass('fa-caret-right').addClass('fa-caret-down');
      icons.removeClass('fa-caret-right').addClass('fa-caret-down');
    } else {
      icon.addClass('fa-caret-right').removeClass('fa-caret-down');
      icons.addClass('fa-caret-right').removeClass('fa-caret-down');
    }
  }
}
