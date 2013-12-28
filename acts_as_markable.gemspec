$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_markable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_markable"
  s.version     = ActsAsMarkable::VERSION
  s.authors     = ["Qi Li"]
  s.email       = ["cloudbsd@gmail.com"]
  s.homepage    = "http://github.com/cloudbsd/acts_as_markable"
  s.summary     = "Acts As Markable Gem."
  s.description = "ActsAsMarkable gem provides a simple way to record users actions."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "sqlite3"
end
