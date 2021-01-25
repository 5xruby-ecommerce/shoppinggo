# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'a

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'babosa', '~> 1.0', '>= 1.0.4'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'aasm', '~> 4.11'
gem 'omniauth', '~> 1.9', '>= 1.9.1'
gem 'omniauth-facebook', '~> 8.0'
gem 'omniauth-google-oauth2', '~> 0.8.1'
gem 'omniauth-github', '~> 1.4'
gem 'figaro', '~> 1.2'
gem 'pg', '~> 1.2', '>= 1.2.3'
gem 'carrierwave', '~> 2.1'
gem 'fog-aws', '~> 3.7'

gem "mini_magick"
gem 'sidekiq', '~>6.0.0'
gem 'acts-as-taggable-on', '~> 7.0'

gem 'dotenv', '~> 2.7.6'
gem 'friendly_id', '~> 5.4.0'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1', '>= 11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.1'
  gem 'rspec-rails', '~> 4.0', '>= 4.0.2'
  gem 'faker', '~> 2.15', '>= 2.15.1'
  gem 'timecop', '~> 0.8.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop', '~> 1.7', require: false
  gem 'spring', '~> 2.1', '>= 2.1.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'foreman', '~> 0.87.2'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver', '~> 3.142', '>= 3.142.7'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '~> 4.4', '>= 4.4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2020', '>= 1.2020.5', platforms: %i[mingw mswin x64_mingw jruby]