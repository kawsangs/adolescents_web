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

  def choose_color_tip
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
      <a type="button"
         title="#{title}"
         data-bs-html="true"
         data-bs-placement="right"
         data-bs-trigger="focus"
         data-bs-toggle="popover"
         role="button"
         tabindex="0"
         class="popover-dismiss ms-2"
         data-bs-content="#{content}">
        #{t("shared.need_help")}
      </a>
    }.html_safe
  end
end
