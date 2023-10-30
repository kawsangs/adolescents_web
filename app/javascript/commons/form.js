import jquerySortable from 'libs/jquerySortable';
import criteria from 'commons/criteria';
import selectPicker from "commons/select_picker";
import tooltip from "commons/tooltip";
import tagList from "commons/tag_list";
import audio from "commons/audio";

export default (function() {
  var resultType = 'Questions::Result';

  var havingOptionQuestionTypes = {
    'Questions::SelectOne': 'd-for-select-one',
    'Questions::SelectMultiple': 'd-for-select-multiple',
    'Questions::Note': 'd-for-note'
  }

  return {
    init,
    onClickAddAssociation,
    onClickRemoveField,
    handleDisplayTagListWrapper
  }

  function init() {
    initView()
    initSortable()
    initSetting()

    onClickAddField()
    onClickRemoveField()
    onClickAddFieldOption()
    onChooseFieldType()

    onClickCollapseTrigger()
    onClickBtnAdd()
    onClickRequireCheckbox()

    onClickSettingItem()
    onClickBtnSetting()

    onClickBtnAdvanceOption()

    audio.init();

    onClickCollapseAllTrigger()
    onClickAddCriteria()
    onChangeQuestionName()

    onChangeTracking()
    initFormTagList()
    initQuestionTagList()
    onChangeChatGroupSelect()

    criteria.init()
  }

  function onChangeChatGroupSelect() {
    $(document).on("change", "select.chat_group_ids", function(e) {
      let select = $(this);
      let chatGroupNames = getChatGroupLabels(select);

      if(!chatGroupNames.length) return hideChatGroup(select);

      showChatGroup(select);
      updateChatGroupTooltip(select, chatGroupNames);
    })
  }

  function updateChatGroupTooltip(select, chatGroupNames) {
    let tooltipSpan = select.parents(".fieldset").find(".notification-wrapper");
    let title = "<div class=\'text-left\'>";
    title += "<span>ក្រុមជជែក</span>: <ol>";
    title += chatGroupNames.map((name) => `<li>${name}</li>`).join("");
    title += "</ol></div>";

    let tooltip = bootstrap.Tooltip.getInstance(tooltipSpan);
    tooltip._config.title = title;
    tooltip.update();
  }

  function showChatGroup(select, chatGroupNames) {
    window.me = select;
    select.parents(".fieldset").find(".chat-group-wrapper").removeClass("d-none");
  }

  function hideChatGroup(select) {
    select.parents(".fieldset").find(".chat-group-wrapper").addClass("d-none");
  }

  function getChatGroupLabels(select) {
    let chatGroupIds = select.parents(".fieldset").find("select.chat_group_ids").map((index, el) => $(el).val()).toArray();
    let chatGroupOptions = select.find("option").filter((index, el) => chatGroupIds.includes(el.value));

    return chatGroupOptions.map((index, el) => el.text).toArray();
  }

  function initFormTagList() {
    tagList.initTagify("input.form-tag-list", {
      options: {
        maxTags: 1
      }
    })
  }

  function initQuestionTagList() {
    let questions = $(".fieldset")

    for(let i=0; i<questions.length; i++) {
      tagList.initTagify($(questions[i]).find('input.tag-list'), {
        options: {
          maxTags: 1
        },
        callback: handleDisplayTagListWrapper
      })
    }
  }

  function onChangeQuestionName() {
    $(document).off('change', '.field-name');
    $(document).on('change', '.field-name', function(e) {
      var value = e.currentTarget.value;
      if (!!value) {
        value = value.split(" ").join("_").toLowerCase().replace(/[^a-zA-Z0-9\_]/g, '');
      }
      $(e.currentTarget).parents('.fieldset').find('.question-code').val(value);
    });
  };

  function onClickCollapseAllTrigger() {
    $(document).off('click', '.collapse-all-trigger');
    $(document).on('click', '.collapse-all-trigger', function(e) {
      let dom = e.currentTarget;
      let content = $('.fieldset').find('.collapse-content');
      let icon = $($(dom).find('i'));
      content.toggle();

      if ($(content).is(":visible")) {
        icon.removeClass('fa-caret-right');
        icon.addClass('fa-caret-down');
        hideSettingContent(this);
      } else {
        icon.addClass('fa-caret-right');
        icon.removeClass('fa-caret-down');
      }
    });
  };

  function onClickBtnAdvanceOption() {
    $(document).off('click', '.btn-advance');
    $(document).on('click', '.btn-advance', function(e) {
      $(this).parents('.field-wrapper').find('.advance-options').toggleClass('d-none');
      e.preventDefault();
    });
  };

  function onClickBtnSetting() {
    $(document).off('click', '.btn-setting');
    $(document).on('click', '.btn-setting', function() {
      toggleSettingContent(this);
      hideCollapseContent(this);
    });
  };

  function toggleSettingContent(dom) {
    $(dom).parents('.fieldset').find('.btn-setting').toggleClass('active');
    $(dom).parents('.fieldset').find('.setting-wrapper').toggle();
  };

  function hideSettingContent(dom) {
    $(dom).parents('.fieldset').find('.btn-setting').removeClass('active');
    $(dom).parents('.fieldset').find('.setting-wrapper').hide();
  };

  function initSetting() {
    $('.item-setting').addClass('active');
    $('.setting-content').show();
  };

  function onClickSettingItem() {
    $(document).off('click', '.setting-wrapper .item');
    $(document).on('click', '.setting-wrapper .item', function(event) {
      $(this).parents('.setting-wrapper').find('.content').hide();
      $(this).parents('.setting-wrapper').find('.item').removeClass('active');
      $(this).parents('.setting-wrapper').find($(this).data('target')).show();
      $(this).addClass('active');
    });
  };

  function onClickRequireCheckbox() {
    $(document).off('click', '.field-required');
    $(document).on('click', '.field-required', function(e) {
      $(this).parents('.fieldset').find('.abbr-required').toggleClass('d-none');
    });
  };

  function initView() {
    return $('input.field-type').each(function(index, dom) {
      if (!dom.value) {
        return;
      }
      initBtnMove(dom);
      initFieldNameStyleAsTitle(dom);
      initCollapseContent(dom);
    });
  }

  function initCollapseContent(dom) {
    hideCollapseContent(dom);

    if(Object.keys(havingOptionQuestionTypes).includes(dom.value)) {
      showCollapseTrigger(dom);
      showOption(dom);
      showContentUnderClass(dom, havingOptionQuestionTypes[dom.value])
    } else if (dom.value == resultType) {
      showResultField(dom);
      showCollapseTrigger(dom);
    }
  };

  function hideCollapseContent(dom) {
    $(dom).parents('.fieldset').find('.collapse-content').hide();
  };

  function showCollapseTrigger(dom) {
    $(dom).parents('.fieldset').find('.collapse-trigger').show();
  };

  function initFieldNameStyleAsTitle(dom) {
    var parentDom;
    parentDom = $(dom).parents('.fieldset');
    parentDom.find('.field-name').addClass('no-style as-title');
    parentDom.find('.btn-add-field').hide();
  };

  function initBtnMove(dom) {
    var btnMove, icon, parentDom;
    parentDom = $(dom).parents('.fieldset');
    icon = parentDom.find("[data-field_type='" + dom.value + "'] .icon").clone();
    btnMove = parentDom.find('.move');
    btnMove.empty();
    btnMove.append(icon);
    btnMove.show();
  };


  function onClickBtnAdd() {
    $(document).off('click', '.btn-add-field');
    $(document).on('click', '.btn-add-field', function(event) {
      var parent;
      $(this).hide();
      parent = $(event.currentTarget).parents('.fieldset');
      parent.find('.field-type-wrapper').show();
      parent.find('.field-name').addClass('no-style');
    });
  };

  function onClickCollapseTrigger() {
    $(document).off('click', '.collapse-trigger');
    $(document).on('click', '.collapse-trigger', function(event) {
      var content, dom, icon;
      dom = event.currentTarget;
      content = $(dom).parents('.fieldset').find('.collapse-content');
      icon = $($(dom).find('i'));
      content.toggle();
      if ($(content).is(":visible")) {
        icon.removeClass('fa-caret-right');
        icon.addClass('fa-caret-down');
        hideSettingContent(this);
      } else {
        icon.addClass('fa-caret-right');
        icon.removeClass('fa-caret-down');
      }
    });
  };

  function hideCollapseContent(dom) {
    var icon;
    icon = $(dom).parents('.fieldset').find('.collapse-trigger i');
    icon.addClass('fa-caret-right');
    icon.removeClass('fa-caret-down');
    $(dom).parents('.fieldset').find('.collapse-content').hide();
  };


  function onClickRemoveField() {
    $(document).on('click', 'form .remove_fields', function(event) {
      event.preventDefault();
      removeField(this);
    });
  };

  function removeField(dom) {
    $(dom).parent().find('input[type=hidden]').val('1');
    $(dom).closest('fieldset').hide();
  };


  function onClickAddField() {
    $(document).off('click', 'form .add_questions');
    $(document).on('click', 'form .add_questions', function(event) {
      appendField(this);
      event.preventDefault();
    });
  };

  function onClickAddAssociation(css_class) {
    if (css_class == null) {
      css_class = 'form .add_association';
    }
    $(document).off('click', css_class);
    $(document).on('click', css_class, function(event) {
      appendField(this);
      return event.preventDefault();
    });
  };

  function onClickAddFieldOption() {
    $(document).off('click', 'form .add_options');
    $(document).on('click', 'form .add_options', function(event) {
      appendField(this);
      event.preventDefault();
    });
  };

  function onClickAddCriteria() {
    $(document).off('click', 'form .add_criterias');
    $(document).on('click', 'form .add_criterias', function(event) {
      var criteriaWrapper;
      event.preventDefault();
      criteriaWrapper = appendField(this);
      criteria.initOptionsToCriteriaQuestionSelect(criteriaWrapper);
    });
  };

  function onChooseFieldType() {
    $(document).off('click', '.field-type-list');
    $(document).on('click', '.field-type-list', function(event) {
      var dom, field_type;
      dom = event.currentTarget;
      field_type = $(dom).data('field_type');

      setFieldNameInputAsTitleStyle(dom);
      assignBtnMove(dom);
      assignFieldType(dom, field_type);
      handleCollapseContent(dom, field_type);
      showBtnSetting(dom);
    });
  };

  function showBtnSetting(dom) {
    $(dom).parents('.fieldset').find('.btn-setting').removeClass('d-none');
    $(dom).parents('.fieldset').find('.item-setting').click();
  };

  function setFieldNameInputAsTitleStyle(dom) {
    var fieldName = $(dom).parents('.fieldset').find('.field-name');
    fieldName.addClass('as-title');
  };

  function handleCollapseContent(dom, field_type) {
    if (Object.keys(havingOptionQuestionTypes).includes(field_type)) {
      showOption(dom);
      initOneOption(dom);
      showArrowDownIcon(dom);
      showContentUnderClass(dom, havingOptionQuestionTypes[field_type])
    } else if (field_type == resultType) {
      showResultField(dom);
      showArrowDownIcon(dom);
    }

    hideFieldTypeList(dom);
  };

  function handleShowingContentForSpecificType(field) {
    let fieldType = field.parents('.fieldset').find('.field-type').val()
    console.log(fieldType)
    showContentUnderClass(field, havingOptionQuestionTypes[fieldType])
  }

  function showContentUnderClass(dom, css_class) {
    $(dom).parents('.fieldset').find(`.${css_class}`).removeClass('d-none');
  }

  function showArrowDownIcon(dom) {
    var btnCollapseTrigger, icon;
    icon = $(dom).parents('.fieldset').find('.collapse-trigger i');
    icon.removeClass('fa-caret-right').addClass('fa-caret-down');
    btnCollapseTrigger = $(dom).parents('.fieldset').find('.collapse-trigger');
    btnCollapseTrigger.show();
  };

  function onChangeTracking() {
    $(document).on("change", "input.tracking-checkbox", function(e) {
      $(this).parents(".fieldset").find(".tracking").toggleClass("d-none", !this.checked);
    })
  }

  function hideFieldTypeList(dom) {
    var fieldTypeWrapper;
    fieldTypeWrapper = $(dom).parents('.fieldset').find('.field-type-wrapper');
    fieldTypeWrapper.hide();
  };

  function showResultField(dom) {
    $(dom).parents('.fieldset').find('.result-type-wrapper').show();
  };

  function assignBtnMove(dom) {
    var btnMove;
    btnMove = $(dom).parents('.fieldset').find('.move');
    btnMove.empty();
    btnMove.append($($(dom).find('.icon')).clone());
    btnMove.show();
  };

  function showOption(dom) {
    $(dom).parents('.fieldset').find('.options-wrapper').show();
  };

  function hideOption(dom) {
    $(dom).parents('.fieldset').find('.options-wrapper').hide();
    clearAllOptions(dom);
  };

  function clearAllOptions(dom) {
    $(dom).parents('.fieldset').find('.options-wrapper .remove_fields').click();
  };

  function assignFieldType(dom, field_type) {
    var fieldType;
    fieldType = $(dom).parents('.fieldset').find('.field-type');
    fieldType.val(field_type);
  };

  function appendField(dom) {
    var time = new Date().getTime();
    var regexp = new RegExp($(dom).data('id'), 'g');
    var field = $($(dom).data('fields').replace(regexp, time));
    field.find('.btn-setting').addClass('d-none');
    $(dom).before(field);
    assignDisplayOrderToListItem();
    selectPicker.init();

    if (!!$(field).find('.tag-list').length) {
      tagList.initTagify($(field).find('.tag-list'), {
        callback: handleDisplayTagListWrapper
      });
    }

    tooltip.init();
    handleShowingContentForSpecificType(field);
    return field;
  };


  function handleDisplayTagListWrapper(dom, tagList) {
    if (!tagList) {
      return hideTagListWrapper(dom);
    }
    showTagListWrapper(dom);
    updateDisplayTagList(dom, tagList);
  };

  function showTagListWrapper(dom) {
    $(dom).parents(".fieldset").find(".tag-list-wrapper").removeClass("d-none");
  };

  function hideTagListWrapper(dom) {
    $(dom).parents(".fieldset").find(".tag-list-wrapper").addClass("d-none");
  };

  function updateDisplayTagList(dom, tagList) {
    var tags, wrapper;
    wrapper = dom.parents(".fieldset").find(".tag-list-wrapper .tag-wrapper");
    tags = tagList.split(",").map((function(_this) {
      return function(tag) {
        return "<small class='tag rounded mr-1'>" + tag + "</small>";
      };
    })(this)).join("");
    return wrapper.html(tags);
  };

  function initOneOption(dom) {
    $(dom).parents('.fieldset').find('.add_options').click();
  };

  function animateListItems($item, container, _super) {
    var $clonedItem;
    $clonedItem = $('<li/>').css({
      height: 0
    });
    $item.before($clonedItem);
    $clonedItem.animate({
      'height': $item.height()
    });
    $item.animate($clonedItem.position(), function() {
      $clonedItem.detach();
      return _super($item, container);
    });
  };

  function assignDisplayOrderToListItem() {
    $('ol.fields li').each(function(index) {
      $(this).find('.display-order').val(index);
    });
  };

  function initSortable() {
    $(document).find('ol.fields.sortable').sortable({
      handle: '.move',
      onDrop: function($item, container, _super) {
        animateListItems($item, container, _super);
        assignDisplayOrderToListItem();
      }
    });
  };
})();
