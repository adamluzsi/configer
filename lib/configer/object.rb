module Configer
  class Object < ::Hash

    self.instance_methods.each do |sym|
      self.__send__ :protected, sym
    end

    def method_missing name,*args

      if name.to_s[-1] == '='
        self[name.to_s[0..-2]]= *args
      else
        self[name.to_s]
      end

    end

    public(:__send__) if $TEST
    public :to_s,:inspect,:delete,:delete_if,:merge!,:merge,
           :each,:each_pair,:map,:reduce,:group_by,
           :keys,:values,:select,:to_a,:grep,:count,:size,
           :==,:===,:include?,:class,:dup,:freeze

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