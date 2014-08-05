module Configer

  class Object < Hash

    self.instance_methods.each do |sym|
      self.__send__ :protected, sym
    end

    def method_missing( method_name, *args )

      if method_name[-1] == '='
        self[method_name[0..-2]]= *args
        return self[method_name[0..-2]]

      else
        #> respond to method only if no value present
        if self[method_name.to_s].nil? && self.respond_to?(method_name)
          return self.__send__(method_name)

        else
          return self[method_name.to_s]

        end

      end

    end

    public :__send__,:public_send,:respond_to?

    #> some allowed Hash methods
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
      key = key.to_s if key.class <= Symbol
      super || super(key.to_sym)
    end

    def []= key,value
      key = key.to_s if key.class <= Symbol
      super
    end

    #> parse object
    def self.parse(obj)

      return case

               when obj.class <= Hash
                 obj.reduce(self.new){|m,h| m.merge!( (h[0].class <= Symbol ? h[0].to_s : h[0] ) => self.parse(h[1]) ) ;m}

               when obj.class <= Array
                 obj.map{|o| self.parse(o) }

               else
                 obj

             end

    end

  end

  module Data

    #> i dont know why , but if i catch this ,
    # than somethimes some object happens to not get parsed
    def self.config_hash
      return Object.parse(Support.mount_config_and_lib_meta)
    end

  end

  class << self

    def new *args
      self::Object.new(*args)
    end

    alias :init :new

    def parse(obj)
      self::Object.parse(obj)
    end

  end

end