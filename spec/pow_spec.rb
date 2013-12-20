require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, '#pow' do
  before do
    @z = MPC.new([0, 1])
  end
  it 'calculates the value of a complaex number raised to a Float power' do
    z = @z ** 0.5

    expect(z.real).to eq GMP::F(0.5).sqrt
    expect(z.imag).to eq GMP::F(0.5).sqrt
  end

  it 'calculates the value of a complaex number raised to a Float power' do
    z = @z ** 2

    expect(z.real).to eq 1
    expect(z.imag).to eq 0

    z = @z ** 3

    expect(z.real).to eq 0
    expect(z.imag).to eq -1
  end
end
