require 'phantom'

describe Phantom do
  pid_file = 'tmp/phantom.pid'

  after(:each) do
    File.delete pid_file if File.exist? pid_file
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
    err = nil
    Phantom.run(pid_file: pid_file, on_ok: lambda{i += 1}, on_error: lambda{|e| err = e}) do
    end
    sleep 3
    i.should == 1
    err.should == nil
  end

  it 'should call on_error when sub process raises an unhandled error' do
    err = nil
    i = 0
    Phantom.run(pid_file: pid_file, on_ok: lambda{i += 1}, on_error: lambda{|e| err = e}) do
      raise 'Wa ha ha!'
      i += 1
    end

    sleep 3

    err.should be_an(StandardError)
    err.message.should == 'Wa ha ha!'
    i.should == 0
  end

  it 'should be OK if pid_file is not given' do
    Phantom.run do end
  end

  it 'should return a Phantom::Base instance when run' do
    phantom = Phantom.run do end
    phantom.should be_an(Phantom::Base)
  end

  it 'should do nothing if block is not given' do
    phantom = Phantom.run
    phantom.pid.should be_nil
  end
end
