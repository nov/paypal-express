Gem::Specification.new do |s|
  s.name = "paypal-express"
  s.version = File.read(File.join(File.dirname(__FILE__), "VERSION"))
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov matake"]
  s.description = %q{PayPal Express Checkout API Client for Instance, Recurring and Digital Goods Payment.}
  s.summary = %q{PayPal Express Checkout API Client for Instance, Recurring and Digital Goods Payment.}
  s.email = "nov@matake.jp"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/nov/paypal-express"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.add_dependency "activesupport", ['>= 2.3', '<= 4.2.5.1']
  s.add_dependency "rest-client"
  s.add_dependency "attr_required", ">= 0.0.5"
  s.add_development_dependency "rake", ">= 0.8"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rspec", "< 2.99"
  s.add_development_dependency "fakeweb", ">= 1.3.0"
end
