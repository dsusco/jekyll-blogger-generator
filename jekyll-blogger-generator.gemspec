require_relative 'lib/jekyll-blogger-generator/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-blogger-generator'
  spec.version       = JekyllBloggerGenerator::VERSION
  spec.authors       = ['David Susco']
  spec.summary       = 'A Blogger generator for Jekyll.'
  spec.homepage      = 'https://github.com/dsusco/jekyll-blogger-generator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR).grep(%r!^lib/!)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.2'

  spec.add_runtime_dependency 'google-apis-blogger_v3', '~> 0.4.0'
  spec.add_runtime_dependency 'activesupport', '~> 6.1.4'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-jekyll', '~> 0.4'
end
