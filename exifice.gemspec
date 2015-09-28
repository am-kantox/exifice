# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exifice/version'

Gem::Specification.new do |spec|
  spec.name          = 'exifice'
  spec.version       = Exifice::VERSION
  spec.authors       = ['Aleksei Matiushkin']
  spec.email         = ['am@mudasobwa.ru']

  spec.summary       = %q{Library to make image rework a pleasure.}
  spec.description   = %q{Utilises a power of exiftool, imagemagick, geocoder and others.}
  spec.homepage      = 'http://rocket-science.ru/rubygems/exifice'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'pry', '~> 0.10'

  spec.add_dependency 'geocoder', '~> 1.2'
  spec.add_dependency 'mini_exiftool', '~> 2.5'
  spec.add_dependency 'mini_magick', '~> 4.3'
  spec.add_dependency 'nokogiri', '~> 1.6'

end
