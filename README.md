configer
========

super easy to use configuration module for ruby apps

### example

```ruby

    require_relative "../lib/configer.rb"

    #>  you can use root/r/folder key,
    #   for set home directory
    #
    #>  you can point to an object if you want change the default __config__ obj
    #   keys: o/out/to
    #
    Configer.mount_yaml
    Configer.mount_json

    # this will merge new objects by default to the __config__ object (or configer)
    puts __config__ #> you can use __CONFIG__ alias as well

    # for example we can call the dir.pwd folder's sample/meta/test.yml file parsed data as
    puts __config__.sample.meta.test #> { hello: "world" }
    puts __config__.sample.meta.test.hello #> "world"

```

example for the mount options:

```ruby

    require "configer"

    asdf= Configer.new( {hello: "world"} )

    Configer.mount_yaml out: asdf
    Configer.mount_json out: asdf

    puts __config__
    #<Configer::ConfigObject>

    puts asdf
    #<Configer::ConfigObject    hello="world"
    #                           sample=#<Configer::ConfigObject meta=#<Configer::ConfigObject
    #                                                           hello=#<Configer::ConfigObject hello="world">
    #                                                           test=#<Configer::ConfigObject hello="world">>>>


```