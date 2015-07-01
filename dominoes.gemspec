# -*- encoding : utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dominoes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dominoes"
  s.version     = Dominoes::VERSION
  s.authors     = ["IdUFF"]
  s.email       = ["iduff@id.uff.br"]
  s.homepage    = "http://www.iduff.br"
  s.summary     = "Training example"
  s.description = "Training example to understand a little more about ruby and testing"

  s.files = Dir["{lib}/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency "rspec", '3.0.0'
  s.add_development_dependency "guard-rspec"
end
