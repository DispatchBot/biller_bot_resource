# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "biller_bot_resource/version"

Gem::Specification.new do |s|
  s.name        = "biller_bot_resource"
  s.version     = BillerBotResource::VERSION
  s.authors     = ["Brad Seefeld"]
  s.email       = ["support@dispatchbot.com"]
  s.homepage    = "https://github.com/bradseefeld/biller_bot_resource"
  s.summary     = %q{Common resources for the BillerBot API}
  s.description = %q{Provides a set of Ruby classes for interacting with the BillerBot API}

  s.rubyforge_project = "biller_bot_resource"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activeresource", "~> 4.0.0"
  s.add_development_dependency "rspec"
end
