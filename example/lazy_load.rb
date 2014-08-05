require "configer"

puts __CONFIG__.public_send(:test)
puts __CONFIG__.test.this.__send__ :class

puts Configer.parse(hello: 'world')
puts __CONFIG__.configer.config.class
