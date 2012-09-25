require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/tanh.dat
describe MPC, '#tanh' do
  it 'should calculate the hyperbolic tangent of a pure real argument' do
    data = [
      ["-0xc2f7d5a8a79ccp-52",   MPC.new([GMP::F(-1, 7), GMP::F(0, 7)])],
      [ "0xc2f7d5a8a79ccp-52",   MPC.new([GMP::F( 1, 7), GMP::F(0, 7)])]
    ]
    data.each do |expected, input|
      actual = input.tanh(MPC::MPC_RNDNN, 50, 50)
      actual.real.should eq GMP::F.new(expected, 50, 16)
      actual.imag.should eq GMP::F(0)
    end
  end

  it 'should calculate the hyperbolic tangent of a pure imaginary argument' do
    data = [
      ["-0x18eb245cbee3a8p-52",   MPC.new([GMP::F(0, 7), GMP::F(-1, 7)])],
      [ "0x18eb245cbee3a8p-52",   MPC.new([GMP::F(0, 7), GMP::F( 1, 7)])]
    ]
    data.each do |expected, input|
      actual = input.tanh(MPC::MPC_RNDNN, 50, 50)
      actual.real.should eq GMP::F(0)
      actual.imag.should eq GMP::F.new(expected, 50, 16)
    end
  end

  it 'should calculate the hyperbolic tangent of an argument with +1 and -1' do
    data = [
      ["-0x1157bffca4a8cp-48", "-0x459193d28cfe2p-52",  MPC.new([GMP::F(-1, 7), GMP::F(-1, 7)])],
      ["-0x1157bffca4a8cp-48",  "0x459193d28cfe2p-52",  MPC.new([GMP::F(-1, 7), GMP::F( 1, 7)])],
      [ "0x1157bffca4a8cp-48", "-0x459193d28cfe2p-52",  MPC.new([GMP::F( 1, 7), GMP::F(-1, 7)])],
      [ "0x1157bffca4a8cp-48",  "0x459193d28cfe2p-52",  MPC.new([GMP::F( 1, 7), GMP::F( 1, 7)])]
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.tanh(MPC::MPC_RNDNN, 50, 50)
      actual.real.should eq GMP::F.new(expected_real, 50, 16)
      actual.imag.should eq GMP::F.new(expected_imag, 50, 16)
    end
  end

  it 'should calculate the hyperbolic sine of ieee-754 double precision numbers' do
    data = [
      [["0x10000000000001p-53", 53, 16], ["0x1FFFFFFFFFFFFFp-53", 53, 16], ["0x1E938CBCEB16DFp-55", 53, 16], ["0x1B1F56FDEEF00Fp-53", 53, 16], MPC::MPC_RNDNN]
    ]
    data.each do |expected_real, expected_imag, input_real, input_imag, rounding_mode|
      actual = MPC.new([GMP::F.new(*input_real), GMP::F.new(*input_imag)]).tanh(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end
end
