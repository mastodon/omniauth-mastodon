lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/mastodon/version'

Gem::Specification.new do |spec|
  spec.authors       = ["Eugen Rochko"]
  spec.email         = "eugen@zeonfederated.com"
  spec.description   = "OmniAuth Strategy for Mastodon"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/tootsuite/omniauth-mastodon"
  spec.licenses      = %w(MIT)
  spec.files         = %w(omniauth-mastodon.gemspec) + Dir['lib/**/*.rb'] + Dir['lib/**/*.yml']
  spec.name          = "omniauth-mastodon"
  spec.require_paths = %w(lib)
  spec.version       = OmniAuth::Mastodon::Version

  spec.add_dependency 'omniauth', '>= 1', '< 3'
  spec.add_dependency 'omniauth-oauth2', '~> 1.1'
  spec.add_dependency 'i18n', '~> 0.7'

  spec.add_development_dependency 'bundler', '~> 1.0'
end
