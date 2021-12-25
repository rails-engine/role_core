# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "role_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "role_core"
  s.version     = RoleCore::VERSION
  s.authors     = ["jasl"]
  s.email       = ["jasl9187@hotmail.com"]
  s.homepage    = "https://github.com/rails-engine/role_core"
  s.summary     = "RoleCore is a Rails engine which could provide essential industry of Role-based access control."
  s.description = "RoleCore is a Rails engine which could provide essential industry of Role-based access control."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "options_model", ">= 0.0.15", "< 1.0"
  s.add_dependency "rails", ">= 5", "< 8"
end
