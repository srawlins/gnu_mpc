require File.join(File.dirname(__FILE__), 'spec_helper')

describe "MPC_SINGLE_FUNCTION args" do
  before do
    @functions = [
      :sin,  :cos,  :tan,
      :sinh, :cosh, :tanh,
      :asin, :acos, :atan
    ]
    @z = MPC.new(0,0)
  end
  it "should accept no arguments" do
    @functions.each do |func|
      expect { @z.send(func) }.to_not raise_error
    end
  end

  it "should accept a single rounding mode argument, MPC_RNDNN" do
    @functions.each do |func|
      expect { @z.send(func, MPC::MPC_RNDNN) }.to_not raise_error
    end
  end

  it "should accept a single rounding mode argument, MPC_RNDZD" do
    @functions.each do |func|
      expect { @z.send(func, MPC::MPC_RNDZD) }.to_not raise_error
    end
  end

  it "should accept a single rounding mode argument and a single precision" do
    @functions.each do |func|
      expect { @z.send(func, MPC::MPC_RNDZZ, 128) }.to_not raise_error
    end
  end

  it "should accept a single rounding mode argument and two precisions" do
    @functions.each do |func|
      expect { @z.send(func, MPC::MPC_RNDZZ, 128, 256) }.to_not raise_error
    end
  end
end
