ruby '2.2.2'

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18.2'
gem 'pg_search', '~> 0.7.8'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# Pagination
gem 'will_paginate', '~> 3.0.7'

# .Env gem Gem
gem 'dotenv-rails'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7', require: 'bcrypt'

# Use puma as the app server
gem 'puma'

# Use responders
gem 'responders'

# Authentication
gem 'devise'
gem 'omniauth'

# Authorization
gem 'pundit'

gem 'time_for_a_boolean'

# Adds enhanced pub/sub hooks
gem 'wisper'

# Tests
group :development, :test do
  gem 'annotate'
  gem 'awesome_print'
  gem 'brakeman', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner', '~> 1.4.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'license_finder'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'rubocop'
  gem 'seed_dump'
  gem 'selenium-webdriver'
  # gem 'poltergeist', require: 'capybara/poltergeist'
  gem 'spring'
  # gem 'web-console', '~> 2.0.0'
  # gem 'capybara-angular', '0.1.0'
  # gem 'launchy'
  gem 'foreman'
end

group :test do
  gem 'rake' # for travis
  gem 'shoulda-matchers', require: false
end

# Documentation
gem 'apipie-rails', '0.3.3'

# Keep but hide deleted records
gem 'paranoia'

# Communicating with external services
gem 'rest-client'
gem 'virtus'

# CRONTAB SCHEDULER
gem 'rufus-scheduler'

# ActiveRecord DelayedJob
gem 'delayed_job_active_record'

# Daemons for DelayedJob
gem 'daemons'

# Get picky about what is put into responses
gem 'active_model_serializers', '~> 0.8.0'

# Gems for Content Pages
gem 'friendly_id'
gem 'paper_trail'

gem 'sass'

group :production, :staging do
  gem 'rails_12factor'
end

# Add Tags
gem 'acts-as-taggable-on'

# Sortable Items
gem 'acts_as_list'

# TO ENCODE DECIMALS AS JSON NUMBERS
gem 'activesupport-json_encoder'

# Resource filtering with scopes
gem 'has_scope'

# Jellyfish Extensions
gem 'jellyfish-aws'
gem 'jellyfish-notification'
gem 'jellyfish-docker', git: 'git://github.com/projectjellyfish/jellyfish-docker.git'

gem 'jellyfish-odl', git: 'git://github.com/projectjellyfish/jellyfish-odl.git'
