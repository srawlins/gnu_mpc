require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "methods with optional hash arguments" do
  before do
    #@z_sqr = MPC.new([GMP::F("0x10000000020000p+04", 53, 16), GMP::F("0x10000000effff", 53, 16)])
    #@z = MPC.new([GMP::F("0x400008000180fp-22", 53, 16), GMP::F("0x7ffff0077efcbp-32", 53, 16)])
    @z_sqr = MPC.new([GMP::F("-0x10000000020000p+04", 53, 16), GMP::F("0x10000000efffefp-04", 53, 16)])
    @z = MPC.new([GMP::F("0x7ffff0077efcbp-32", 53, 16), GMP::F("0x400008000180fp-22", 53, 16)])
  end

  it "should allow #sqr to accept :rounding_mode hash argument" do
    @z.sqr(:rounding_mode => MPC::MPC_RNDZZ).should eq @z_sqr
    @z.sqr(:rounding => MPC::MPC_RNDZZ).should eq @z_sqr
    @z.sqr(:round => MPC::MPC_RNDZZ).should eq @z_sqr
    @z.sqr(:rnd => MPC::MPC_RNDZZ).should eq @z_sqr
  end
end
