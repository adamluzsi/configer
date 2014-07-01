
require 'hashie'

%W[ data ].each do |name_tag|
  require File.expand_path File.join File.dirname(__FILE__),'..','lib','configer',name_tag
end

var = Configer.new(
    {
        capacity: {
            max: 9000
        }
    }
)

puts var
# puts var.public_methods