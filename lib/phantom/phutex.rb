module Phantom
  class Phutex
    def initialize(lock_path)
      @path = lock_path
    end

    def sync(&block)
      raise ArgumentError.new('Block must be given.') if not block_given?
      File.open(@path, 'w') do |f|
        f.flock(File::LOCK_EX)
        block.call
      end
    end
    
  end
end