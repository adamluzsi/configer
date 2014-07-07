configer
========
super easy to use configuration module for ruby apps

### install

 $ gem install configer

### example

#### Lazy Config object

The configers default behavior is , when you put a yaml or a json file into the following directories
* app_root/lib/meta/**/*
* app_root/lib/meta/*
* app_root/lib/custom_libary_name/meta/*
* app_root/config/*
* app_root/config/environments/*

The meta tag can be aliased with META

The logic is the following:
* in the lib/meta/*
    * will be merged into the __config__ hash object under the key of the file name 
* in the lib/meta/folder/*
    * will be merged into the __config__ object with the folder as main key and under that file name as key for the content
* in the lib/folder/meta/*
    * will be merged into the __config__ object with the folder as main key, and the file names as sub keys followed by the content
* in the config/* && config/environments/*
    * will be merged into the __config__ object as is. Deep merge will used so already existing keys will only be override partially
    * the following is the order if yaml/json files names as enviornments
        * default
        * development
        * test
        * production

I personally say, put everything into the lib/gem_name/meta/* so you can have auto separated configs for each gem/module
The __config__ object will not be generated util it's being called.

#### Loading up Yaml and Json files from the application directory

You can mount JSON and yaml files with manually.
This will make key paths based on FileSystem logic

```ruby

    require "configer"

    #> optons:
    #
    # root/r/folder/dir/directory 
    #   - set the folder where the mount will begin
    #
    # to/out/o
    #   - point to a hashlike object where you want the config objects to be merged
    #
    Configer.mount_yaml #> return Configer::Object that contain parsed yaml
    Configer.mount_json #> return Configer::Object that contain parsed json

```

example for the mount options:

```ruby

    require "configer"

    asdf = {hello: "world"} 

    Configer.mount_yaml out: asdf
    Configer.mount_json out: asdf

    puts asdf

```