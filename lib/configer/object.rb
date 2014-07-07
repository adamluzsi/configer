
module Configer

  class Object < ::Hash

    self.instance_methods.each do |sym|
      self.__send__ :protected, sym
    end

    def method_missing name,*args

      if name.to_s[-1] == '='
        self[name.to_s[0..-1]]= *args
      else
        self[name.to_s]
      end

    end

    public :to_s,:inspect,:delete,:delete_if,:merge!,:merge,
           :each,:each_pair,:map,:reduce,:group_by,
           :keys,:values,:select,:to_a,:grep,:count,:size,
           :==,:===,:include?

    public

    def [] key
      key = key.to_s
      super
    end

    def []= key,value
      key = key.to_s
      super
    end

  end
  module Data
    def self.config_hash
      @@config ||= Object.new.merge!(Support.mount_config_and_lib_meta)
    end
  end

  class << self

    def new *args
      self::Object.new(*args)
    end

    alias :init :new

  end

end