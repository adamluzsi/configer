module Configer

  class Instance

    include Helpers

    include Cache::Logic
    attr_reader :get_pwd
    def initialize(pwd)

      raise(
          ArgumentError,
          'Configer::Instance can only be made with valid folder path!'
      ) unless File.exist?(pwd)

      @get_pwd = pwd

    end

  end

  def self.new(pwd)
    self::Instance.new(pwd)
  end

end
