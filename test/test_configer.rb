require_relative 'test_helper'
describe 'configer' do

  it 'should be able to fetch values with different access' do

    var = __config__ #> put into variable for check cache

    #> test caching
    __config__.__send__(:object_id).must_be :==,var.__send__(:object_id)

    #> test accessing logic
    __config__.default_key.must_be :==,__config__['default_key']
    __config__.default_key.must_be :==,__config__[:default_key]
    __config__.default_key.must_be :==,__config__.public_send(:default_key)

  end

  it 'should mount all the config files up!' do

    #> config && erb
    __config__.default_key.must_be :==,'default_value'
    __config__.module_name.module_name_key.hello.must_be_instance_of Float
    __config__.sub_key.must_be_instance_of Float

    #> config/env
    if Configer.env == 'development'
      __config__.development_key.must_be :==, 'yep'
    else
      __config__.development_key.must_be :==, nil
    end

    #> lib/meta
    __config__.module_name.module_name_key.module_name_value_hash_key.must_be :==, 'module_name_value_hash_value'

    #> lib/module_name/meta
    __config__.sample.config.config_key.must_be :==,'config_value'

    #> string value in config object /as yaml format/
    __config__.sample.string.must_be :==,'hello world!'

  end

end