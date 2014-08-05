require "configer"

puts __CONFIG__.public_send(:test)
puts __CONFIG__

puts Configer.parse(hello: 'world')