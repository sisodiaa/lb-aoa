source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0", ">= 7.0.2.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

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
gem "image_processing", "~> 1.2"

# Implement state machines
gem "aasm", "~> 5.2"

# Flexible authentication solution for Rails with Warden
gem "devise", "~> 4.8", ">= 4.8.1"

# Object oriented authorization for Rails applications
gem "pundit", "~> 2.1", ">= 2.1.1"

# For pagination
gem "pagy", "~> 5.9", ">= 5.9.3"

# For mailers and background jobs
gem "sidekiq", "~> 6.4", ">= 6.4.1"

# Manage S3 bucket to store documents
gem "aws-sdk-s3", "~> 1.113"

# Drop-in plug-in for ActionMailer to send emails via Postmark
gem "postmark-rails", "~> 0.22.0"

# Sitemap generator
gem "sitemap_generator", "~> 6.2", ">= 6.2.1"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  gem "solargraph", "~> 0.44.2", require: false
  gem "standard", "~> 1.7", require: false
  gem "rubocop-rails", "~> 2.13", ">= 2.13.2", require: false

  # N+1 auto-detection for Rails with zero false positives / false negative
  gem "prosopite", "~> 1.0", ">= 1.0.8"
  gem "pg_query", "~> 2.1", ">= 2.1.3" # required by prosopite when using pg
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Static analysis security vulnerability scanner
  gem "brakeman", "~> 5.2", ">= 5.2.1"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"

  # Code coverage
  gem "simplecov", "~> 0.21.2", require: false
end
