configer
========

super easy to use configuration module for ruby apps.

### install

 $ gem install configer

### Description

Configer is a support gem, to give the developer ability,
creating meta config files, that should be loaded into the application.

Configer follow the traditional ways in this field, and use the following Filesystem logic:

mounting configuration files as they are

 ./project_dir/config/*

mounting environment configuration file as they are based on the current envernioment stage (development,test,production,staging)
* envirnomens folder name can be also envs/env/environment

 ./project_dir/config/environments/*

mounting configuration files from lib/meta folder.
* Each config file name will be a "key" in the main config object
  * same goes with the folders in the meta file
  * the serialized object will be the value

 ./project_dir/lib/meta/**/*

mounting configuration files from lib/module_name/meta folder.
* Each config file name will be a "key" in the config object that is located under the module_name key in the main config object
  * same goes with the folders in the meta file
  * the serialized object will be the value

 ./project_dir/lib/module_name/meta/**/*


The meta folder name can be aliased with META

#### example

in the /test/sample_root you can see an example

#### Lazy Config object

The __config__ object will not be generated util it's being called.

#### Instance

config object can be made into simple instance, based on argument passed folder path

#### ERB support

config files support ERB parsing if the file contain .erb extension in the name

#### Supported Serializations

the current supported parsing logic are Yaml and JSON, that could be mixed with ERB

### example

__config__.grape.defaults #> return the config object that is located under {"grape"=>{"defaults"=>{...}}}

### after words

I personally say, put everything into the lib/gem_name/meta/**/* so you can have auto separated configs for each gem/module


