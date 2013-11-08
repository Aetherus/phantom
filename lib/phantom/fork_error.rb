module Phantom
  class ForkError < Exception
    attr_reader :pid, :pid_file

    def initialize(message, pid_file)
      super(message)
      @pid_file = pid_file
      @pid = File.read @pid_file
    end
  end
end