require 'phantom'

describe Phantom::Base do
  it 'should be kill the process when called on abort' do
    i = 0
    phantom = Phantom.run do
      sleep 3
      i = 1
    end
    phantom.abort
    sleep 5
    i.should == 0
  end
end