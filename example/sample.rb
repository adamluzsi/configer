require "configer"

asdf = {hello: "world"}

Configer.mount_yaml out: asdf
Configer.mount_json out: asdf

puts asdf