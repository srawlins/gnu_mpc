require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/cosh.dat
describe MPC, '#cosh' do
  it 'calculates the hyperbolic cosine of special values' do
    data = [
      [1,   MPC.new([GMP::F(0, 2), GMP::F(0, 2)])]
    ]
    data.each do |expected, input|
      actual = input.cosh(MPC::MPC_RNDNN, 2, 2)
      expect(actual.real).to eq GMP::F.new(expected, 2)
      expect(actual.imag).to eq GMP::F(0)
    end
  end

  it 'calculates the hyperbolic sine of ieee-754 double precision numbers' do
    data = [
      [["0x10000000000001p-53", 53, 16], ["0x10000000000001p-52", 53, 16], ["0x1DA2E1BD2C9EBCp-53", 53, 16], ["0x138AADEA15829Fp-52", 53, 16], MPC::MPC_RNDNN],
    ]
    data.each do |expected_real, expected_imag, input_real, input_imag, rounding_mode|
      actual = MPC.new([GMP::F.new(*input_real), GMP::F.new(*input_imag)]).cosh(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end
end
