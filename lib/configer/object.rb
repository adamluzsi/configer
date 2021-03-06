module Configer

  class Object < Hash

    include HashExtension
    self.instance_methods.each do |sym|
      protected sym
    end

    public :__send__,:public_send,:[],:[]=
    def method_missing( method_name, *args, &block )

      obj_methods = self.__send__(:methods)
      if method_name[-1] == '=' && !obj_methods.include?(method_name)
        self[method_name[0..-2]]= *args
        return self[method_name[0..-2]]

      elsif self[method_name.to_s].nil? && obj_methods.include?(method_name)

        if block_given?
          return self.__send__(method_name,*args,&block)
        else
          return self.__send__(method_name,*args)
        end

      else
        return self[method_name.to_s]

      end

    end

    public

    def [](key)
      key = key.to_s if key.class <= Symbol
      super || super(key.to_sym)
    end

    def []=(key,value)
      key = key.to_s if key.class <= Symbol
      super
    end

    #> parse object
    def self.parse(obj)
      case obj

        when Hash
          obj.reduce(self.new){|m,h|
            m.deep_merge!( (h[0].class <= Symbol ? h[0].to_s : h[0] ) => self.parse(h[1]) ) ;m}

        when Array
          obj.map{|o| self.parse(o) }

        else
          obj

      end

    end

  end

end