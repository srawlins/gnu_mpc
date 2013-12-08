require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "#fma" do
  before do
    @a = MPC.new([2, 0])
    @b = MPC.new([1, 2])
    @c = MPC.new([2, 2])
  end

  it "returns the product of an MPC and the first argument, and summed with the second argument" do
    expect(@a.fma(@b, @c)).to eq(MPC.new([4, 6]))
  end

  it "accepts hash options" do
    result = @a.fma(@b, @c, prec: 32)
    expect(result).to eq(MPC.new([4, 6]))
    expect(result.real.prec).to eq 32
    expect(result.imag.prec).to eq 32
  end
end
