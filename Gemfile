# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in role_core.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

gem "sqlite3", "~> 1.3.6"

# Use Puma as the app server
gem "puma"
# For better console experience
gem "pry-rails"
# Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
gem "web-console"
gem "listen", ">= 3.0.5", "< 3.2"
# Call "byebug" anywhere in the code to stop execution and get a debugger console
gem "pry-byebug"

gem "better_errors"
gem "binding_of_caller"

# To support ES6
gem "sprockets", "~> 4.0.0.beta4"
# Use SCSS for stylesheets
gem "sassc-rails"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

gem "turbolinks", "~> 5"
gem "jquery-rails"
gem "bulma-rails", "~> 0.5"

gem "cancancan"

gem "rubocop"
gem "rubocop-rails_config"
