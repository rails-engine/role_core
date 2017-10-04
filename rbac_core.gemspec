# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rbac_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rbac_core"
  s.version     = RbacCore::VERSION
  s.authors     = ["jasl"]
  s.email       = ["jasl9187@hotmail.com"]
  s.homepage    = "https://github.com/jasl-lab/rbac_core"
  s.summary     = "A Rails engine providing essential industry of Role-based access control"
  s.description = "A Rails engine providing essential industry of Role-based access control"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0"
  s.add_dependency "options_model", "~> 0"
end
