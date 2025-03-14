# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.3-1/lib/assets/compiled/rails-ujs.js"

pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js", preload: true
pin "moment", to: "https://ga.jspm.io/npm:moment@2.29.4/moment.js", preload: true
pin "moment/min/moment-with-locales.min.js", to: "https://ga.jspm.io/npm:moment@2.29.4/min/moment-with-locales.min.js", preload: true
pin "daterangepicker", to: "https://ga.jspm.io/npm:daterangepicker@3.1.0/daterangepicker.js", preload: true

# It is in betta vesion, and it supports bootstrap 5
pin "bootstrap-select", to: "https://ga.jspm.io/npm:bootstrap-select@1.14.0-beta3/dist/js/bootstrap-select.js", preload: true
pin "@yaireo/tagify", to: "https://ga.jspm.io/npm:@yaireo/tagify@4.16.4/dist/tagify.min.js", preload: true
pin "nouislider", to: "https://ga.jspm.io/npm:nouislider@15.6.1/dist/nouislider.js", preload: true

pin "jquery-minicolors", to: "https://ga.jspm.io/npm:jquery-minicolors@2.1.10/jquery.minicolors.js", preload: true

# Typeahead
pin "typeahead", to: "https://ga.jspm.io/npm:typeahead@0.2.2/typeahead.js", preload: true
pin "dom", to: "https://ga.jspm.io/npm:dom@0.0.2/index.js", preload: true
pin "xtend", to: "https://ga.jspm.io/npm:xtend@1.0.3/index.js", preload: true
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js", preload: true

pin_all_from "app/javascript/libs", under: "libs", preload: true
pin_all_from "app/javascript/commons", under: "commons", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
