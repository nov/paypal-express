Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.1.2'
  s.name = "creative-paypal-express"
  s.version = File.read(File.join(File.dirname(__FILE__), "VERSION"))
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov matake", "CreativeGS"]
  s.description = %q{PayPal Express Checkout API Client for Instance, Recurring and Digital Goods Payment.}
  s.summary = %q{PayPal Express Checkout API Client for Instance, Recurring and Digital Goods Payment.}
  s.email = "hi@creative.gs"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/CreativeGS/paypal-express"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency "activesupport", ">= 4"
  s.add_dependency "rest-client"
  s.add_dependency "attr_required", ">= 0.0.5"

  s.add_development_dependency "activesupport", "4.1" # uses this for development, but will probably work with higher versions
  s.add_development_dependency "rake", ">= 0.8"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rspec", "< 2.99"
  s.add_development_dependency "fakeweb", ">= 1.3.0"
end
