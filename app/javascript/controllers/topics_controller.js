import { Controller } from "@hotwired/stimulus";
import jquerySortable from 'jquerySortable';
import Tagify from "@yaireo/tagify"

export default class extends Controller {
  static targets = [ "btnAddQuestion", "btnCollapseAllTrigger", "serviceIdsInput" ]

  connect() {
    this._initQuestionView();
    this._initSortable();

    this._initValueForInputService();
    this._initServiceTagify();
  }

  _getServices() {
    return $(this.serviceIdsInputTarget).data('collection').map(x => ({"value": x.id, "name": x.name}));
  }

  _initValueForInputService() {
    let services = this._getServices() || [];
    let serviceIds = $(this.serviceIdsInputTarget).val().split(' ');
    let values = services.filter(s => serviceIds.includes(s.value));

    $(this.serviceIdsInputTarget).val(JSON.stringify(values));
  }

  _initServiceTagify() {
    let self = this;
    var tagify = new Tagify(document.querySelector('input[name="topic[service_ids]"]'), {
        delimiters : null,
        templates : {
            tag : this._tagTemplate,
            dropdownItem : this._dropdownItemTemplate
        },
        enforceWhitelist : true,
        whitelist : self._getServices(),
        dropdown : {
            enabled: 1, // suggest tags after a single character input
            classname : '', // custom class for the suggestions dropdown
            enabled: 0,
            closeOnSelect: true
        },
        searchKeys: ['name'],
        originalInputValueFormat: (valuesArr) => valuesArr.map(item => item.value)
    })
  }

  _tagTemplate(tagData) {
    try{
        return `<tag title='${tagData.name}' contenteditable='false' spellcheck="false" class='tagify__tag ${tagData.class ? tagData.class : ""}' ${this.getAttributes(tagData)}>
                <x title='remove tag' class='tagify__tag__removeBtn'></x>
                <div>
                    <span class='tagify__tag-text'>${tagData.name}</span>
                </div>
            </tag>`
    }
    catch(err){}
  }

  _dropdownItemTemplate(tagData) {
    try {
        return `<div ${this.getAttributes(tagData)} class='tagify__dropdown__item ${tagData.class ? tagData.class : ""}' >
                    <span>${tagData.name}</span>
                </div>`
    }
    catch(err){ console.error(err)}
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
      this._showCollapseTrigger(dom)
      this._showOption(dom)
    }
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
