module ThemesHelper
  def asset_image_title(asset)
    I18n.t("theme.image_title_#{asset.image_dimension}")
  end

  def ios_assets(assets)
    assets.select { |asset| asset.platform == "ios" }
          .sort_by! { |asset| %w(1x 2x 3x).index(asset.resolution) || 0 }
  end

  def android_assets(assets)
    assets.select { |asset| asset.platform == "android" }
          .sort_by! { |asset| %w(mdpi hdpi xhdpi xxhdpi).index(asset.resolution) || 0 }
  end

  def resolutions
    {
      android: [
        ['mdpi', 'android_mdpi'],
        ['hdpi', 'android_hdpi'],
        ['xhdpi', 'android_xhdpi'],
        ['xxhdpi', 'android_xxhdpi']
      ],

      ios: [
        ['1x', 'ios_1x'],
        ['2x', 'ios_2x'],
        ['3x', 'ios_3x']
      ]
    }
  end

  def mobile_menus
    [
      { image: 'categories/reproduction_health.png', title: 'សុខភាពផ្លូវភេទនិងសុខភាពបន្តពូជ'},
      { image: 'categories/understanding_gender.png', title: 'យេនឌ័រនិងនិន្នាការភេទ'},
      { image: 'categories/drug_and_alcohol_prevention.png', title: 'ការបង្ការគ្រឿងញៀននិងគ្រឿងស្រវឹង'},
      { image: 'categories/understanding_hiv.png', title: 'ការយល់ដឹងពីមេរោគអេដស៍និងជំងឺកាមរោគ'},
      { image: 'categories/youth_migration.png', title: 'ចំណាកស្រុកយុវជន'},
      { image: 'categories/clinic_and_examination_service.png', title: 'គ្លីនិកនិងសេវា'},
      { image: 'categories/mental_support.png', title: 'សេវាគាំទ្រផ្លូវចិត្ត'}
    ]
  end

  def mobile_tab_menus
    [
      { icon_class: 'fa-solid fa-house', title: 'ទំព័រដើម'},
      { icon_class: 'fa-solid fa-circle-play', title: 'វីដេអូ'},
      { icon_class: 'fa-solid fa-location-dot', title: 'គ្លីនិក'},
      { icon_class: 'fa-solid fa-message', title: 'ជំនួយ'}
    ]
  end

  def create_theme_tip
    title = t('theme.tip.title')
    content = %Q{
      #{t('theme.tip.introduction')}
      <ul>
        <li>#{t('theme.tip.high_contrast')}</li>
        <li>#{t('theme.tip.primary_and_secondary_color')}</li>
        <li>#{t('theme.tip.check_standard')}</li>
      </ul>

      #{t('theme.tip.use_tool')}
    }

    %Q{
      <a type="button" title="#{title}" data-bs-html="true" data-bs-placement="right" data-bs-trigger="focus" data-bs-toggle="popover" role="button" tabindex="0" class="popover-dismiss ms-2" data-bs-content="#{content}">
        <i class='fa-solid fa-circle-question'></i>
        #{t("theme.need_help")}
      </a>
    }.html_safe
  end

  def primary_color_tip
    content = %Q{
      <h5 class="text-dark">#{t('theme.primary_color')}</h5>
      <ul class="ps-3 mt-2">
        <li>#{t('theme.primary_color_tip.use_as_background_color')}</li>
        <li>#{t('theme.primary_color_tip.apply_to_navbar_color')}</li>
        <li>#{t('theme.primary_color_tip.set_button_color')}</li>
        <li>#{t('theme.primary_color_tip.additional_tip')}</li>
      </ul>
    }

    render_popover(nil, content)
  end

  def secondary_color_tip
    content = %Q{
      <h5 class="text-dark">#{t('theme.secondary_color')}</h5>
      <ul class="ps-3 mt-2">
        <li>#{t('theme.secondary_color_tip.utilized_as_second_linear_bg')}</li>
        <li>#{t('theme.secondary_color_tip.mark_active_menu')}</li>
        <li>#{t('theme.secondary_color_tip.additional_use')}</li>
      </ul>
    }

    render_popover(nil, content)
  end

  def primary_text_color_tip
    content = %Q{
      <h5 class="text-dark">#{t('theme.primary_text_color')}</h5>
      <ul class="ps-3 mt-2">
        <li>#{t('theme.primary_text_color_tip.define_text_color_on_navbar')}</li>
        <li>#{t('theme.primary_text_color_tip.use_for_headings')}</li>
      </ul>
    }

    render_popover(nil, content)
  end

  def secondary_text_color_tip
    content = %Q{
      <h5 class="text-dark">#{t('theme.secondary_text_color')}</h5>
      <ul class="ps-3 mt-2">
        <li>#{t('theme.secondary_text_color_tip.set_paragraph_text_color')}</li>
        <li>#{t('theme.secondary_text_color_tip.apply_to_sub_title_color')}</li>
        <li>#{t('theme.secondary_text_color_tip.additional_use')}</li>
      </ul>
    }

    render_popover(nil, content)
  end

  def theme_background_image_tip
    content = %Q{
      <h5 class="text-dark">#{t('theme.theme_bg_images')}</h5>
      <p>#{t('theme.bg_image_tip.how_to_use')}</p>
      <p>#{t('theme.bg_image_tip.user_update_bg_image')}</p>
    }

    render_popover(nil, content)
  end

  def render_popover(title, content)
    %Q{
      <a type="button" title="#{title}" data-bs-html="true" data-bs-placement="right" data-bs-trigger="focus" data-bs-toggle="popover" role="button" tabindex="0" class="popover-dismiss ms-2" data-bs-content='#{sanitize(content)}'>
        <i class='fa-solid fa-circle-exclamation'></i>
      </a>
    }.html_safe
  end
end
