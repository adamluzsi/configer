# coding: utf-8

Gem::Specification.new do |spec|

  spec.name          = 'configer'
  spec.version       = File.open(File.join(File.dirname(__FILE__),'VERSION')).read.split("\n")[0].chomp.gsub(' ','')
  spec.authors       = ['Adam Luzsi']
  spec.email         = ['adamluzsi@gmail.com']
  spec.description   = %q{ Easy to use config module. Based on generally accepted FileSystem positions, check gitHub for more info }
  spec.summary       = %q{ Clean and easy to use config module for general use }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.homepage      = "https://github.com/adamluzsi/#{__dir__.split(File::Separator).last.split('.').first}"

  spec.required_ruby_version = '>= 2.0.0'
  
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

end
