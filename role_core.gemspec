# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "role_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "role_core"
  s.version     = RoleCore::VERSION
  s.authors     = ["jasl"]
  s.email       = ["jasl9187@hotmail.com"]
  s.homepage    = "https://github.com/jasl-lab/role_core"
  s.summary     = "A Rails engine providing essential industry of Role-based access control"
  s.description = "A Rails engine providing essential industry of Role-based access control"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2", "< 6.0"
  s.add_dependency "options_model", "~> 0"
end
