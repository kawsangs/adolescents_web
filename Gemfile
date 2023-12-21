source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Sigin
gem "devise", "~> 4.8.1"
gem "omniauth-rails_csrf_protection", "~> 1.0.1"
gem "omniauth-google-oauth2", "~> 1.0.1"
gem "omniauth-facebook", "~> 9.0.0"
gem "recaptcha", "~> 5.10.0"

# Oauth authentication
gem "doorkeeper", "~> 5.5.4"

# View
gem "haml-rails", "~> 2.0.1"
gem "simple_form", "~> 5.1.0"
gem "bootstrap", "~> 5.2.0"
gem "sass-rails", "~> 6.0.0"

# Permission
gem "pundit", "~> 2.2.0"

# Pagination
gem "pagy", "~> 5.10.1"

# Soft delete
gem "paranoia", "~> 2.6.0"

# Nested level
gem "awesome_nested_set", "~> 3.5.0"

# Tracking change
gem "audited", "~> 5.0"

# Background process
gem "sidekiq", "~> 6.5.4"

# Client request
gem "httparty", "~> 0.21.0"

gem "sentry-ruby"
gem "sentry-rails"

# Write excel
gem "caxlsx", "~> 3.2.0"
gem "caxlsx_rails", "~> 0.6.3"

# Cambodia Location
gem "jquery-rails", "~> 4.5.0"
gem "pumi", require: "pumi/rails"

# For error tracking alert
gem "sentry-ruby"
gem "sentry-rails"

# Read excel
gem "roo", "~> 2.9.0"

# Strip space
gem "strip_attributes", "~> 1.13.0"

# Serializer
gem "active_model_serializers", "~> 0.10.13"

# Restrict cross platform access
gem "rack-cors", "~> 1.1.1"

# Push notification
gem "googleauth", "1.2.0"
gem "fcm", "~> 1.0.8"

# File upload
gem "carrierwave",    "~> 2.2.2"
gem "fog-aws",        "~> 3.15.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "factory_bot_rails"
  gem "ffaker"
  gem "rspec-rails"
  gem "database_cleaner-active_record"
  gem "byebug"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "annotate"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "shoulda-matchers"
  gem "rspec-sidekiq"
end
