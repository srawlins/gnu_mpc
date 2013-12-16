require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, '#initialize without precision or rounding args' do
  before do
    @z1 = GMP::Z(8)
    @z2 = GMP::Z(-13)
    @q1 = GMP::Q(1,3)
    @q2 = GMP::Q(-2,3)
    @f1 = GMP::F(1.5)
    @f2 = GMP::F(-2.5)
    @big_2_64 = 2**64
    @big_2_65 = 2**65
    @z_2_64 = GMP::Z(2**64)
    @z_2_65 = GMP::Z(2**65)
  end
  it 'does not raise anything when initialized with no args' do
    expect { MPC.new() }.to_not raise_error
  end

  it 'does not raise anything when initialized with 0' do
    expect { MPC.new(0) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a negative Fixnum' do
    expect { MPC.new(-32) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a positive Fixnum' do
    expect { MPC.new(32) }.to_not raise_error
  end

  it "can be instantiated from a Bignum" do
    expect { MPC.new(@big_2_64) }.to_not raise_error
    expect(MPC.new(@big_2_64)).to eq(MPC.new(@z_2_64))
  end

  it 'does not raise anything when initialized with 0.0' do
    expect { MPC.new(0.0) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a positive Float' do
    expect { MPC.new(3.14) }.to_not raise_error
    expect { MPC.new(1.618) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a positive GMP::Z' do
    expect { MPC.new(@z1) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a negative GMP::Z' do
    expect { MPC.new(@z2) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a positive GMP::Q' do
    expect { MPC.new(@q1) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a negative GMP::Q' do
    expect { MPC.new(@q2) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a positive GMP::F' do
    expect { MPC.new(@f1) }.to_not raise_error
  end

  it 'does not raise anything when initialized with a negative GMP::F' do
    expect { MPC.new(@f2) }.to_not raise_error
  end

  it 'does not raise anything when initialized with an Array of 0\'s' do
    expect { MPC.new([0,0]) }.to_not raise_error
  end

  it 'does not raise anything when initialized with an Array of Fixnum\'s' do
    expect { MPC.new([-2**10, 2**11]) }.to_not raise_error
  end

  it "can be instantiated from two Bignums" do
    expect { MPC.new([@big_2_64, @big_2_65]) }.to_not raise_error
    expect(MPC.new([@big_2_64, @big_2_65])).to eq(MPC.new([@z_2_64, @z_2_65]))
  end

  it 'does not raise anything when initialized with an Array of Float\'s' do
    expect { MPC.new([1.4142135623730951, 1.4142135623730951]) }.to_not raise_error
  end

  it 'does not raise anything when initialized with an Array of GMP::Z\'s' do
    expect { MPC.new([@z1, @z2]) }.to_not raise_error
  end

  it 'does not raise anything when initialized with an Array of GMP::Q\'s' do
    expect { MPC.new([@q1, @q2]) }.to_not raise_error
  end

  it 'does not raise anything when initialized with an Array of GMP::F\'s' do
    expect { MPC.new([@f1, @f2]) }.to_not raise_error
  end

  it 'raises TypeError when initialized with an Array of mixed types' do
    expect { MPC.new([0, 0.0]) }.to raise_error(TypeError)
    expect { MPC.new([0, @z1]) }.to raise_error(TypeError)
    expect { MPC.new([@f1, 0.0]) }.to raise_error(TypeError)
    expect { MPC.new([@z1, @f1]) }.to raise_error(TypeError)
    expect { MPC.new([@q1, 42]) }.to raise_error(TypeError)
  end

  it 'initializes default values correctly' do
    expect(MPC.new(0)).to eq MPC.new()
    expect(MPC.new(0.0)).to eq MPC.new()
  end

  it 'raises when the precision is out-of-bounds' do
    expect { MPC.new(0, -1) }.to raise_error(RangeError)
    expect { MPC.new(0, 0) }.to raise_error(RangeError)
    expect { MPC.new(0, 1) }.to raise_error(RangeError)
  end
end
