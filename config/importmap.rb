# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.3-1/lib/assets/compiled/rails-ujs.js"

pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js"
pin "moment", to: "https://ga.jspm.io/npm:moment@2.29.4/moment.js"
pin "moment/min/moment-with-locales.min.js", to: "https://ga.jspm.io/npm:moment@2.29.4/min/moment-with-locales.min.js"
pin "daterangepicker", to: "https://ga.jspm.io/npm:daterangepicker@3.1.0/daterangepicker.js"

# richtext editor
pin "tinymce", to: "https://cdn.tiny.cloud/1/xlg2815iyuokkkbrkx4pr9pd7hebttvudistnzl7mgmlkyde/tinymce/6/tinymce.min.js"

# It is in betta vesion, and it supports bootstrap 5
pin "bootstrap-select", to: "https://ga.jspm.io/npm:bootstrap-select@1.14.0-beta3/dist/js/bootstrap-select.js"
pin "@yaireo/tagify", to: "https://ga.jspm.io/npm:@yaireo/tagify@4.16.4/dist/tagify.min.js"
pin "nouislider", to: "https://ga.jspm.io/npm:nouislider@15.6.1/dist/nouislider.js"

# Typeahead
pin "typeahead", to: "https://ga.jspm.io/npm:typeahead@0.2.2/typeahead.js"
pin "dom", to: "https://ga.jspm.io/npm:dom@0.0.2/index.js"
pin "xtend", to: "https://ga.jspm.io/npm:xtend@1.0.3/index.js"
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js"

pin_all_from "app/javascript/libs", under: "libs", preload: true
pin_all_from "app/javascript/commons", under: "commons", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
