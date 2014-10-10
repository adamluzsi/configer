$TEST = true

#> TEST dir root
Dir.chdir(File.realpath(File.join(__dir__,'sample_root')))

require 'configer'
require 'minitest/autorun'
