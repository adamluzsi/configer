$TEST = true

#> TEST dir root
Dir.chdir(
    File.expand_path(
        File.join(
            File.dirname(__FILE__),
            'sample_root'
        )
    )
)

require 'configer'
require 'minitest/autorun'
