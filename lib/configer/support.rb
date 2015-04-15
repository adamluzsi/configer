module Configer

  class << self

    def pwd

      if defined?(Rails) && !Rails.root.nil?
        Rails.root.to_s
      elsif ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'].split(File::Separator)[0..-2].join(File::Separator)
      else
        Dir.pwd.to_s
      end

    end


    def env

      if defined?(Rails) && !Rails.env.nil?
        return Rails.env.to_s

      elsif !ENV['RAILS_ENV'].nil?
        return ENV['RAILS_ENV'].to_s

      elsif !ENV['RACK_ENV'].nil?
        return ENV['RACK_ENV'].to_s

      elsif !ENV['STAGE'].nil?
        case ENV['STAGE'].to_s.downcase

          when /^dev/
            return 'development'

          when /^test/
            return 'test'

          when /^prod/,/^stag/
            return 'production'

          else
            return ENV['STAGE']

        end

      else
        return ENV.find{|k,v|
          %W[ production development ].include?(v.to_s)
        } || 'development'

      end

    end

  end
end
