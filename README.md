configer
========

super easy to use configuration module for ruby apps

### example

```ruby

    require_relative "../lib/configer.rb"

    Configer.mount_yaml
    Configer.mount_json

    # this will return the config obj
    puts configer #> || use config alias

    # for example we can call the root/sample/meta/test.yml file parsed data as
    puts configer.sample.meta.test #> { hello: world }
    puts configer.sample.meta.test.hello #> { hello: world }


```