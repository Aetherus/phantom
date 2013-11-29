require 'phantom'

describe Phantom::Base do

  count_file = 'tmp/count.txt'

  after(:each) do
    File.delete count_file if File.exists? count_file
    @error = nil
  end

  it 'should kill the process when called on abort' do
    phantom = Phantom.run do
      sleep 3
      File.new(count_file, 'w').close
    end
    phantom.abort!
    sleep 5
    File.should_not exist(count_file)
    phantom.status.should == Phantom::Status::DEAD
  end

  it 'should kill the process when called on terminate' do
    phantom = Phantom.run(on_error: lambda{|e| @error = e}) do
      sleep 3
      File.new(count_file, 'w').close
    end
    phantom.terminate
    sleep 5
    File.should_not exist(count_file)
    phantom.status.should == Phantom::Status::DEAD
    @error.should be_nil
  end

  it 'should be able to pause and to resume the process' do
    phantom = Phantom.run do
      loop do
        File.open(count_file, 'a') {|f| f.write 'P'}
      end
      sleep 0.5
    end
    sleep 3
    phantom.pause
    current = File.read(count_file)
    sleep 3
    File.read(count_file).should == current
    phantom.status.should == Phantom::Status::PAUSED

    phantom.resume
    sleep 3
    phantom.status.should == Phantom::Status::ALIVE

    phantom.terminate
    sleep 3
    File.read(count_file).length.should > current.length
  end

  it 'should be able to identify if the process is alive' do
    phantom = Phantom.run do
      @i += 1
      sleep 0.5
    end
    phantom.should be_alive
    phantom.status.should == Phantom::Status::ALIVE

    phantom.terminate

    sleep 0.5

    phantom.should be_dead
    phantom.status.should == Phantom::Status::DEAD
  end

end