require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "precision arguments" do
  before do
    @z = MPC.new([1.0, Math::PI])
  end

  it "returns precision with :prec and :prec2" do
    sqr = @z.sqr(prec: 32)
    expect(sqr.prec).to eq 32
    expect(sqr.prec2).to eq [32, 32]

    sqr = @z.sqr(real_prec: 64, imag_prec: 32)
    expect(sqr.prec).to eq 0
    expect(sqr.prec2).to eq [64, 32]
  end
end
