module Phantom
  class Base
    attr_reader :pid, :name

    def initialize(pid, name=nil)
      @pid = pid.nil? ? nil : pid.to_i
      @name = name
    end
    
    def kill(signal)
      Process.kill(signal, @pid) if @pid
    end
    
    def sid
      @sid ||= Process.getsid(@pid)
    end
    
    def gid
      @gid ||= Process.getpgid(@pid)
    end
    
    def user_priority
      @user_priority ||= Process.getpriority(Process::PRIO_USER, @pid)
    end
    
    def group_priority
      @group_priority ||= Process.getpriority(Process::PRIO_PGRP, @pid)
    end
    
    def process_priority
      @process_priority ||= Process.getpriority(Process::PRIO_PROCESS, @pid)
    end
    
    def abort!
      kill(:ABRT) if alive?
    end

    def terminate
      kill(:TERM) if alive?
    end

    def stop
      if alive?
        kill(:STOP)
        @status = Phantom::Status::PAUSED
      end
    end
    alias :pause :stop

    def continue
      if alive?
        kill(:CONT)
        @status = Phantom::Status::ALIVE
      end
    end
    alias :resume :continue

    def status
      begin
        Process.kill(0, @pid)
        return @status ||= Phantom::Status::ALIVE
      rescue Errno::ESRCH
        return @status = Phantom::Status::DEAD
      end
    end

    def alive?
      !dead?
    end

    def dead?
      status == Phantom::Status::DEAD
    end
  end
end
