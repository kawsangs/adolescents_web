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
      <strong class="text-dark">Primary Color</strong>
      <ul class="ps-3 mt-2">
        <li>Used as the <strong>background color</strong> for key UI elements to establish the app’s core identity.</li>
        <li>Applied to the <strong>navbar color</strong> (e.g., <code>bg-primary</code>) to create a cohesive header that stands out.</li>
        <li>Sets the <strong>button color</strong> for primary actions (e.g., <code>btn-primary</code> for "Submit," "Save," or "Next") to draw user attention.</li>
        <li>Additional use: Highlights <strong>focused input fields</strong> or <strong>active states</strong> (e.g., <code>border-primary</code> on selected toggle switches).</li>
      </ul>
    }

    render_popover(nil, content)
  end

  def secondary_color_tip
    content = %Q{
      <strong class="text-dark">Secondary Color</strong>
      <ul class="ps-3 mt-2">
        <li>Utilized as the <strong>second linear background</strong> in a gradient, styled as <code>linear-gradient(135deg, ${secondaryColor}, ${primaryColor})</code>, for visually engaging backgrounds (e.g., splash screens, hero sections).</li>
        <li>Marks the <strong>active menu item</strong> in a tab menu (e.g., <code>active</code> class with <code>bg-secondary</code>) to indicate the current selection.</li>
        <li>Additional use: Applied to <strong>accent borders</strong> (e.g., <code>border-secondary</code> on card outlines) or <strong>hover effects</strong> on interactive elements.</li>
      </ul>
    }

    render_popover(nil, content)
  end

  def primary_text_color_tip
    content = %Q{
      <strong class="text-dark">Primary Text Color</strong>
      <ul class="ps-3 mt-2">
        <li>Defines the <strong>text color on the navbar</strong> (e.g., <code>text-light</code> or <code>text-dark</code> depending on contrast) for high readability against the primary color background.</li>
        <li>Used for <strong>headings</strong> or <strong>emphasized text</strong> (e.g., <code>h1</code>, <code>h2</code>) throughout the app to maintain hierarchy and focus.</li>
      </ul>
    }

    render_popover(nil, content)
  end

  def secondary_text_color_tip
    content = %Q{
      <strong class="text-dark">Secondary Text Color</strong>
      <ul class="ps-3 mt-2">
        <li>Sets the <strong>paragraph text color</strong> on white backgrounds (e.g., #6c757d or darker) for general content to ensure readability.</li>
        <li>Applied to <strong>subtitles</strong>, <strong>captions</strong>, or <strong>placeholders</strong> for softer contrast where needed.</li>
        <li>Additional use: Colors <strong>inactive tab labels</strong> for subtle differentiation.</li>
      </ul>
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
