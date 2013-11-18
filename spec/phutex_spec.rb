require 'rspec'
require 'phantom'

describe Phantom::Phutex do

  def lock_file
    'tmp/.lock'
  end

  def data_file
    'tmp/test'
  end

  after do
    File.delete(lock_file)
    File.delete(data_file)
  end

  it 'should synchronize jobs in multiple processes' do

    2.times do
      Phantom.run do
        Phantom::Phutex.new(lock_file).sync do
          File.open(data_file, 'a') do |f|
            f.write('hello, ')
            sleep(2)
            f.write('world. ')
          end
        end
      end
    end

    sleep(6)
    File.read(data_file).should == 'hello, world. ' * 2
  end
end