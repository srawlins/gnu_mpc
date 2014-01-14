require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "precision arguments" do
  before do
    @z = MPC.new([1.0, Math::PI])
  end

  it "returns precision with #prec and #prec2" do
    sqr = @z.sqr(prec: 32)
    expect(sqr.prec).to eq 32
    expect(sqr.prec2).to eq [32, 32]

    sqr = @z.sqr(real_prec: 64, imag_prec: 32)
    expect(sqr.prec).to eq 0
    expect(sqr.prec2).to eq [64, 32]
  end

  it "can set precision with #prec=" do
    z = MPC.new(2**10)
    z.prec = 4
    expect(z.prec).to eq 4
    expect(z).to eq(1020)
  end

  it "can set precision with #set_prec" do
    z = MPC.new(2**10)
    z.set_prec 4
    expect(z.prec).to eq 4
    expect(z).to eq(1020)

    z = MPC.new(3**20)
    z.set_prec(8, MPC::MPC_RNDUU)
    expect(z.prec).to eq 8
    expect(z).to eq(3.490e+9)

    z = MPC.new(3**20)
    z.set_prec(8, MPC::MPC_RNDDD)
    expect(z.prec).to eq 8
    expect(z).to eq(3.473e+9)
  end
end
