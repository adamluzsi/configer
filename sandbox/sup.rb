require 'configer'

var = Configer::Object.new
var[:hello] = "world"
var[:max] = "world"

puts var.max
puts var