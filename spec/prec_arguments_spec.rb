require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "precision arguments" do
  before do
    @z = MPC.new([1.0, Math::PI])
  end

  it "accepts :prec and :precision" do
    sqr = @z.sqr(prec: 32)
    expect(sqr.real.prec).to eq 32
    expect(sqr.imag.prec).to eq 32

    sqr = @z.sqr(precision: 32)
    expect(sqr.real.prec).to eq 32
    expect(sqr.imag.prec).to eq 32
  end

  it "accepts :real_prec and :imag_prec" do
    sqr = @z.sqr(imag_prec: 32)
    expect(sqr.real.prec).to eq 53
    expect(sqr.imag.prec).to eq 32

    sqr = @z.sqr(real_prec: 64, imag_prec: 32)
    expect(sqr.real.prec).to eq 64
    expect(sqr.imag.prec).to eq 32

    sqr = @z.sqr(real_precision: 64, imag_precision: 32)
    expect(sqr.real.prec).to eq 64
    expect(sqr.imag.prec).to eq 32
  end

  it "only accepts Fixnum for precision arguments" do
    expect { @z.sqr(prec: 1.2) }.to raise_error(TypeError)
    expect { @z.sqr(precision: 1.2) }.to raise_error(TypeError)
    expect { @z.sqr(real_prec: 1.2) }.to raise_error(TypeError)
    expect { @z.sqr(real_precision: 1.2) }.to raise_error(TypeError)
    expect { @z.sqr(imag_prec: 1.2) }.to raise_error(TypeError)
    expect { @z.sqr(imag_precision: 1.2) }.to raise_error(TypeError)
  end
end
