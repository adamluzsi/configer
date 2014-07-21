module Configer

  class Object < ::Hash

    self.instance_methods.each do |sym|
      self.__send__ :protected, sym
    end

    def method_missing( method_name, *args )

      if method_name.to_s[-1] == '='
        self[method_name.to_s[0..-2]]= *args
        return self[method_name.to_s[0..-2]]
      else

        if self[method_name.to_s].nil? && self.respond_to?(method_name)
          return self.__send__(method_name)
        else
          return self[method_name.to_s]
        end

      end

    end

    public :__send__,:public_send,:respond_to?

    #> allowed Hash methods
    public :to_s,:inspect,:delete,:delete_if,
           :merge!,:merge,:keys,:values,:freeze

    #> allowed Enumerable methods
    public :each,:each_pair,:map,:reduce,:group_by,
           :select,:to_a,:grep,:count,:size

    #> allowed object methods
    public :class,:dup

    #> allowed boolean methods
    public :==,:===,:include?

    public

    def [] key
      key = key.to_s
      super
    end

    def []= key,value
      key = key.to_s
      super
    end

    #> parse object
    def self.parse obj
      raise(ArgumentError,"input must be Hash") unless obj.is_a? ::Hash

      hash = self.new.merge!(obj)
      hash.each_pair do |key,value|
        if value.class <= ::Hash
          hash[key]= self.parse(value)
        end
      end
      return hash

    end

  end

  module Data
    def self.config_hash
      return @@config ||= Object.parse(Support.mount_config_and_lib_meta)
    end
  end

  class << self

    def new *args
      self::Object.new(*args)
    end

    alias :init :new

  end

end