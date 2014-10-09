# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "narray_miss/version"

Gem::Specification.new do |s|
  s.name        = "narray_miss"
  s.version     = NArrayMiss::VERSION
  s.authors     = ["Seiya Nishizawa"]
  s.email       = ["seiya@gfd-dennou.org"]
  s.homepage    = "http://ruby.gfd-dennou.org/products/narray_miss/"
  s.summary     = %q{Additional class with processing of missing value to NArray}
  s.description = %q{NArrayMiss is an additional class with processing of missing value to NArray which is a numeric multi-dimensional array class.}

  s.rubyforge_project = "narray_miss"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  #s.extensions << "ext/extconf.rb"

  # specify any dependencies here; for example:
  #s.add_development_dependency "rspec"
  s.add_runtime_dependency "narray"
end
