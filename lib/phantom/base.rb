module Phantom
  class Base
    attr_reader :pid, :status

    def initialize(pid)
      @pid = pid
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
    
    def abort
      kill(:TERM)
    end
    
  end
end
