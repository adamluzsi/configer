module Configer

  def self.new(pwd)

    raise(
        ArgumentError,
        'Configer::Instance can only be made with valid folder path!'
    ) unless File.exist?(pwd)

    return Object.parse(Configer.mount_all(pwd))

  end

end
