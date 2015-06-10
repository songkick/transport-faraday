Gem::Specification.new do |s|
  s.name                  = "songkick-transport-faraday"
  s.version               = "0.0.1"
  s.license               = "MIT"
  s.summary               = "Faraday adapter for Songkick::Transport"
  s.description           = "Faraday adapter for Songkick::Transport"
  s.authors               = ["Robin Tweedie"]
  s.email                 = "developers@songkick.com"
  s.homepage              = "http://github.com/songkick/transport-faraday"
  s.required_ruby_version = '>= 1.8.7'

  s.require_paths     = %w[lib]

  s.files = %w[README.md] + Dir.glob("{examples,lib,spec}/**/*.rb") + Dir.glob("{examples,lib,spec}/**/*.erb")

  s.add_dependency "songkick-transport", ">= 1.7.0"

  s.add_development_dependency "faraday", ">= 0.9.0"

  s.add_development_dependency "rspec"
end
