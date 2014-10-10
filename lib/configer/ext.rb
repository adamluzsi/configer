module Configer

  module HashExtension

    def deep_merge(other_hash)
      return self.dup.deep_merge!(other_hash)
    end

    def deep_merge!(other_hash)

      other_hash.each_pair do |k,v|
        self[k] = if self[k].class <= ::Hash && v.class <= ::Hash

                    [self[k],v].each do |obj|
                      obj.__send__ :extend, HashExtension unless obj.respond_to?(:deep_merge!)
                    end

                    self[k].deep_merge(v)

                  else
                    v
                  end

      end

      return self

    end

  end


end