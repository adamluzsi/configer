require_relative "../lib/configer.rb"

Configer.mount_yaml
Configer.mount_json

configer #> config

# for example we can call the root/sample/meta/test.yml file parsed data as
puts configer.sample.meta.test #> { hello: world }