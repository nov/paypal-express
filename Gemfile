source 'https://rubygems.org'

platform :jruby do
  gem 'jruby-openssl', '>= 0.7'
end

if ENV['RAILS_VERSION']
  gem 'activesupport', ENV['RAILS_VERSION']

  gem 'iconv' if ENV['RAILS_VERSION'] == '~> 2.3'
end

gemspec
