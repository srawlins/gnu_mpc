Gem::Specification.new do |s|
  s.name = "gnu_mpc"
  s.version = "0.8.2"
  s.authors = ["srawlins"]
  s.date = "2012-10-26"
  s.description = "gnu_mpc - providing Ruby bindings to the MPC library."
  s.email = ["sam.rawlins@gmail.com"]

  s.extensions = ["ext/extconf.rb"]
  s.add_dependency "gmp", ">=0.5.47"

  s.has_rdoc = "yard"
  s.homepage = "http://github.com/srawlins/gnu_mpc"
  s.summary = "Provides Ruby bindings to the MPC library."

  s.required_ruby_version = '>= 1.8.7'
  s.requirements = ["MPC compiled and working properly."]
  s.require_paths = ["lib"]
  s.files  = Dir["ext/*.c"] + Dir["ext/*.h"] + ["ext/extconf.rb"]
  s.files += Dir["lib/mpc.rb"]

  s.files += Dir["spec/*.rb"]
  s.files += ["README.md", "CHANGELOG", "COPYING.md"]
  s.files += ["manual.md", "manual.pdf", "manual_template.latex"]
  s.files += ["Makefile", "Rakefile", "Gemfile", "Guardfile"]
  s.files += [".yardopts", ".rspec"]
end
