$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foodsoft_orderdoc/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foodsoft_orderdoc"
  s.version     = FoodsoftOrderdoc::VERSION
  s.authors     = ["wvengen"]
  s.email       = ["dev-foodsoft@willem.engen.nl"]
  s.homepage    = "https://github.com/foodcoop-adam/foodsoft"
  s.summary     = "Foodsoft plugin using supplier-supplier order spreadsheets."
  s.description = "Replaces CSV order fax with a spreadsheet based on the template the supplier had sent before."

  s.files = Dir["{app,config,db,lib}/**/*", "README.md"]

  s.add_dependency 'rails'
  s.add_dependency 'deface', '~> 1.0.0'
  s.add_dependency 'mimemagic'
  # requires OpenOffice.org to be installed too
end
