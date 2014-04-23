# coding: utf-8

Gem::Specification.new do |spec|

  spec.name          = "configer"
  spec.version       = File.open(File.join(File.dirname(__FILE__),"VERSION")).read.split("\n")[0].chomp.gsub(' ','')
  spec.authors       = ["Adam Luzsi"]
  spec.email         = ["adamluzsi@gmail.com"]
  spec.description   = %q{ Easy to use config module for apps. Use file system based paths for yaml files, to create sub keys }
  spec.summary       = %q{ super easy to use config module for general use }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "hashie"
  spec.add_dependency "loader"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

end
