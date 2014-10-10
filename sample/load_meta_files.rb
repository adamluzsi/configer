require 'configer'

Configer.mount_yaml
Configer.mount_json

__CONFIG__ #> config

# for example we can call the root/sample/meta/test.yml file parsed data as
puts __CONFIG__.sample.meta.test #> { hello: world }

config_obj= {}
