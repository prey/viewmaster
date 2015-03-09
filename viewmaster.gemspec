$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "viewmaster/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "viewmaster"
  s.version     = Viewmaster::VERSION
  s.authors     = ["miguel michelson"]
  s.email       = ["miguelmichelson@gmail.com"]
  s.homepage    = "http://prey.com"
  s.summary     = "Manage multiple layout versions of your app with Viewmaster."
  s.description = "Manage multiple layout versions of your app with Viewmaster."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.4"
  s.add_dependency "request_store"

  s.add_development_dependency "sqlite3"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-mocks"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "shoulda-matchers", "~>1.0"#, "~> 3.0"
  s.add_development_dependency "database_cleaner"
end
