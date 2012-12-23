# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spartan/version"

Gem::Specification.new do |s|
  s.name        = "spartan"
  s.version     = Spartan::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Avdi Grimm"]
  s.email       = ["avdi@avdi.org"]
  s.homepage    = ""
  s.summary     = %q{Butt-naked Ruby testing}
  s.description = <<END
Write tests as plain Ruby examples. Generate Markdown documentation from your tests.
END

  s.rubyforge_project = "spartan"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rcodetools", "~> 0.8"

  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "test-construct", "~> 1.2"
end
