# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.3-1/lib/assets/compiled/rails-ujs.js"

pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Common util
pin "timeago", to: "commons/timeago", preload: true
pin "tooltip", to: "commons/tooltip", preload: true
pin "alert", to: "commons/alert", preload: true
pin "select_picker", to: "commons/select_picker", preload: true
pin "filter_date_picker", to: "commons/filter_date_picker", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"

pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js"
pin "moment", to: "https://ga.jspm.io/npm:moment@2.29.4/moment.js"
pin "moment/min/moment-with-locales.min.js", to: "https://ga.jspm.io/npm:moment@2.29.4/min/moment-with-locales.min.js"
pin "daterangepicker", to: "https://ga.jspm.io/npm:daterangepicker@3.1.0/daterangepicker.js"

# It is in betta vesion, and it supports bootstrap 5
pin "bootstrap-select", to: "https://ga.jspm.io/npm:bootstrap-select@1.14.0-beta3/dist/js/bootstrap-select.js"
pin "@yaireo/tagify", to: "https://ga.jspm.io/npm:@yaireo/tagify@4.16.4/dist/tagify.min.js"
