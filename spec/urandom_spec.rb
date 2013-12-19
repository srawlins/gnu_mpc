require File.join(File.dirname(__FILE__), 'spec_helper')

describe "generating random complex numbers" do
  it "generates random numbers inside the unit square" do
    rs = GMP::RandState.new
    10.times do
      z = rs.mpc_urandom
      expect(z.real).to be <= 1
      expect(z.real).to be >= 0
      expect(z.imag).to be <= 1
      expect(z.imag).to be >= 0
    end
  end
end
