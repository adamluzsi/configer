require "configer"

asdf= Configer::ConfigObject.new( {hello: "world"} )

Configer.mount_yaml out: asdf
Configer.mount_json out: asdf

puts __config__
#<Configer::ConfigObject>

# puts asdf
#<Configer::ConfigObject hello="world" sample=#<Configer::ConfigObject meta=#<Configer::ConfigObject hello=#<Configer::ConfigObject hello="world"> test=#<Configer::ConfigObject hello="world">>>>
