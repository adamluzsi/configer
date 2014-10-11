require_relative 'test_helper'

describe 'configer' do

  before do
    @config = Configer.new(File.join(File.realpath(__dir__),'sample_root'))
  end

  it 'should be able to fetch values with different access' do

    var = @config #> put into variable for check cache

    #> test caching
    @config.__send__(:object_id).must_be :==,var.__send__(:object_id)

    #> test accessing logic
    @config.default_key.must_be :==,@config['default_key']
    @config.default_key.must_be :==,@config[:default_key]
    @config.default_key.must_be :==,@config.public_send(:default_key)

  end

  it 'should mount all the config files up!' do

    #> config && erb
    @config.default_key.must_be :==,'default_value'
    @config.module_name.module_name_key.hello.must_be_instance_of Float
    @config.sub_key.must_be_instance_of Float

    #> config/env
    if Configer.env == 'development'
      @config.development_key.must_be :==, 'yep'
    else
      @config.development_key.must_be :==, nil
    end

    #> lib/meta
    @config.module_name.module_name_key.module_name_value_hash_key.must_be :==, 'module_name_value_hash_value'

    #> lib/module_name/meta
    @config.sample.config.config_key.must_be :==,'config_value'

    #> string value in config object /as yaml format/
    @config.sample.string.must_be :==,'hello world!'

  end

end