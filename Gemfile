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

gem "rails", "~> 7.0"
gem "sqlite3"

# Use Puma as the app server
gem "puma"
# Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
gem "listen"
gem "web-console", group: :development
# Call "byebug" anywhere in the code to stop execution and get a debugger console
gem "byebug", group: %i[development test]

# To support ES6
gem "sprockets"
# Use SCSS for stylesheets
gem "sassc-rails"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

gem "bulma-rails", "~> 0.5"
gem "jquery-rails"
gem "turbolinks", "~> 5"

gem "cancancan"

gem "rubocop"
gem "rubocop-performance"
gem "rubocop-rails"
