require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, '#to_s with base argument only' do
  before do
    @a = MPC.new(13)
  end

  it 'should convert to_s correctly in default base' do
    @a.to_s.should eq '(1.3000000000000000e+1 +0)'
  end

  it 'should convert to_s correctly in base 2' do
    @a.to_s(2).should eq '(1.1010000000000000000000000000000000000000000000000000p+3 +0)'
  end

  it 'should convert to_s correctly in base 3' do
    @a.to_s(3).should eq '(1.1100000000000000000000000000000000@+2 +0)'
  end

  it 'should convert to_s correctly in base 4' do
    @a.to_s(4).should eq '(3.10000000000000000000000000@+1 +0)'
  end

  it 'should convert to_s correctly in base 8' do
    @a.to_s(8).should eq '(1.500000000000000000@+1 +0)'
  end

  it 'should convert to_s correctly in base 8' do
    @a.to_s(8).should eq '(1.500000000000000000@+1 +0)'
  end

  it 'should convert to_s correctly in base 10' do
    @a.to_s(10).should eq '(1.3000000000000000e+1 +0)'
  end

  it 'should convert to_s correctly in base 16' do
    @a.to_s(16).should eq '(d.0000000000000 +0)'
  end

  it 'should convert to_s correctly in base 32' do
    @a.to_s(32).should eq '(d.00000000000 +0)'
  end
end

describe MPC, '#to_s with base argument only' do
  before do
    @a = MPC.new(13)
  end

  it 'should convert to_s correctly with 0 sig figs' do
    @a.to_s(10, 0).should eq '(1.3000000000000000e+1 +0)'
  end

  it 'should convert to_s correctly with 1 sig figs' do
    @a.to_s(10, 1).should eq '(1.e+1 +0)'
  end

  it 'should convert to_s correctly with 2 sig figs' do
    @a.to_s(10, 2).should eq '(1.3e+1 +0)'
  end

  it 'should convert to_s correctly with 4 sig figs' do
    @a.to_s(10, 4).should eq '(1.300e+1 +0)'
  end

  it 'should convert to_s correctly with 8 sig figs' do
    @a.to_s(10, 8).should eq '(1.3000000e+1 +0)'
  end

  it 'should convert to_s correctly with 16 sig figs' do
    @a.to_s(10, 16).should eq '(1.300000000000000e+1 +0)'
  end

  it 'should convert to_s correctly with 32 sig figs' do
    @a.to_s(10, 32).should eq '(1.3000000000000000000000000000000e+1 +0)'
  end
end
