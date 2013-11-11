module Phantom

  class << self
    def run(pid_file: nil, on_ok: nil, on_error: nil, &block)
      return Phantom::Base.new(nil) unless block_given?

      raise ForkError.new('Running process exists.', pid_file) if pid_file and File.exist?(pid_file)

      i, o = IO.pipe
      f = File.new(pid_file, 'w') if pid_file

      pid = fork do
        at_exit do
          o.flush
          o.close
          File.delete pid_file if pid_file
        end
        
        trap(:TERM) do
          Process.abort
        end
        
        i.close
        begin
          block.call if block_given?
          Marshal.dump(Status::OK, o)
        rescue StandardError => e
          Marshal.dump(e, o)
        end
      end

      Process.detach(pid)
      f.write(pid.to_s) if pid_file
      f.close if pid_file
      o.close

      Thread.abort_on_exception = true
      Thread.new do
        begin
          status = Marshal.load(i)
          if status == Status::OK then
            on_ok.call if on_ok
          else
            on_error.call(status) if on_error
          end
        rescue Errno::EPIPE, EOFError => e
          on_error.call(e) if on_error
        ensure
          i.close
        end
      end

      return Phantom::Base.new(pid)
    end
  end
end
