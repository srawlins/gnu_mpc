require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, '#pow' do
  before do
    @w = MPC.new([0, 1])
  end

  it 'calculates the value of a complex number raised to a Fixnum power' do
    w = @w.pow 2

    expect(w.real).to eq -1
    expect(w.imag).to eq 0

    w = @w.pow 3

    expect(w.real).to eq 0
    expect(w.imag).to eq -1
  end

  it 'calculates the value of a complex number raised to a GMP::Z power' do
    w = @w.pow GMP::Z(4)

    expect(w.real).to eq 1
    expect(w.imag).to eq 0
  end

  it 'calculates the value of a complaex number raised to a Float power' do
    w = @w.pow 0.5

    expect(w.real).to eq GMP::F(0.5).sqrt
    expect(w.imag).to eq GMP::F(0.5).sqrt
  end

  it 'calculates the value of a complaex number raised to a GMP::F power' do
    w = @w.pow GMP::F(0.5)

    expect(w.real).to eq GMP::F(0.5).sqrt
    expect(w.imag).to eq GMP::F(0.5).sqrt
  end
end

describe MPC, '#**' do
  before do
    @w = MPC.new([0, 1])
  end

  it 'calculates the value of a complex number raised to a Fixnum power' do
    w = @w ** 2

    expect(w.real).to eq -1
    expect(w.imag).to eq 0

    w = @w ** 3

    expect(w.real).to eq 0
    expect(w.imag).to eq -1
  end

  it 'calculates the value of a complex number raised to a GMP::Z power' do
    w = @w ** GMP::Z(4)

    expect(w.real).to eq 1
    expect(w.imag).to eq 0
  end

  it 'calculates the value of a complaex number raised to a Float power' do
    w = @w ** 0.5

    expect(w.real).to eq GMP::F(0.5).sqrt
    expect(w.imag).to eq GMP::F(0.5).sqrt
  end

  it 'calculates the value of a complaex number raised to a GMP::F power' do
    w = @w ** GMP::F(0.5)

    expect(w.real).to eq GMP::F(0.5).sqrt
    expect(w.imag).to eq GMP::F(0.5).sqrt
  end

  it "raises an exception when presented with 0 or 4 arguments" do
    expect { @w.pow() }.to raise_error(ArgumentError)
  end
end
