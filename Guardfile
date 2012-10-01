require 'fileutils'

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard 'shell' do
  watch(/ext\/(.*).c/) do |m|
    system("cd ext && make; cd ..")
    FileUtils.touch Dir.glob(File.join('lib', 'mpc.rb')).first # force the rspec guard to fire
  end
end
