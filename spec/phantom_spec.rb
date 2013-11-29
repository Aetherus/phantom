require 'phantom'

describe Phantom do
  pid_file = 'tmp/phantom.pid'
  sub_pid_file = 'tmp/sub.pid'

  after(:each) do
    [pid_file, sub_pid_file].each do |file|
      File.delete file if File.exist? file
    end
    @error = nil
  end

  it 'should remove the pid file when normally ends.' do
    failed = false
    Phantom.run(pid_file: pid_file, on_error: lambda{ failed = true }) {
      raise 'PID file not found.' unless File.exists? pid_file
    }
    sleep 1
    failed.should == false
    File.should_not exist(pid_file)
  end

  it 'should raise error if pre-exists pid file' do
    File.new(pid_file, 'w').close
    expect{
      Phantom.run(pid_file: pid_file) do end
    }.to raise_error(Phantom::ForkError)
  end

  it 'should call on_ok when sub processed normally ends' do
    i = 0
    Phantom.run(pid_file: pid_file, on_ok: lambda{i += 1}, on_error: lambda{|e| @error = e}) do
    end
    sleep 3
    i.should == 1
    @error.should be_nil
  end

  it 'should call on_error when sub process raises an unhandled error' do
    i = 0
    Phantom.run(pid_file: pid_file, on_ok: lambda{i += 1}, on_error: lambda{|e| @error = e}) do
      raise SyntaxError
      i += 1
    end

    sleep 3

    @error.should be_a(SyntaxError)
    i.should == 0
  end

  it 'should be OK if pid_file is not given' do
    Phantom.run do end
  end

  it 'should return a Phantom::Base instance when run' do
    phantom = Phantom.run do end
    phantom.should be_a(Phantom::Base)
  end

  it 'should do nothing if block is not given' do
    phantom = Phantom.run
    phantom.pid.should be_nil
  end

  it 'should not call on_error if sub process calls exit' do
    Phantom.run(on_error: lambda{|e| @error = e}) do
      exit
    end
    @error.should be_nil
  end

  it 'should be able to fork sub-sub processes' do
    Phantom.run(pid_file: pid_file, on_error: lambda{|e| @error = e}) do
      Phantom.run(pid_file: sub_pid_file, on_error: lambda{|e| raise e}) do end
      sleep 5
    end
    @error.should be_nil
    sleep 1
    File.should exist(pid_file)
    File.should_not exist(sub_pid_file)
    sleep 5
    File.should_not exist(pid_file)
  end
end
