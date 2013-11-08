module Phantom
  class Base
    attr_reader :pid, :status

    def initialize(pid)
      @pid = pid
    end
  end
end