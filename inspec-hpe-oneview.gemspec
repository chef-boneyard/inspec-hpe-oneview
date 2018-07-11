# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'inspec-hpe-oneview/version'

Gem::Specification.new do |spec|
  spec.name          = 'inspec-hpe-oneview'
  spec.version       = InSpecOneview::VERSION
  spec.authors       = ['Stuart Paterson']
  spec.email         = ['spaterson@chef.io']
  spec.summary       = 'InSpec HPE Oneview'
  spec.description   = 'HPE Oneview InSpec plugin.'
  spec.homepage      = 'https://github.com/inspec/inspec-hpe-oneview'
  spec.license       = 'Apache-2.0'

  spec.files = %w[
    README.md inspec-hpe-oneview.gemspec Gemfile
  ] + Dir.glob(
                 '{bin,docs,examples,lib,tasks,test}/**/*', File::FNM_DOTMATCH
               ).reject { |f| File.directory?(f) }

  spec.require_paths = ['lib']

  #  We will need a version of inspec with the train changes for 'oneview' -> 'iaas' -> 'api' platform detection
  spec.add_dependency 'inspec', '>=2.1.78'
  spec.add_dependency 'oneview-sdk'
end
