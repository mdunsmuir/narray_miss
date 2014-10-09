require 'rbconfig' unless defined? RbConfig
begin
  require "bundler/gem_tasks"
  require "rake/testtask"

  Rake::TestTask.new
  task :default => :test
rescue LoadError
end


destdir = ENV["DESTDIR"] || ""
sitelibdir = ENV["SITELIBDIR"] || RbConfig::CONFIG["sitelibdir"]

LIBS = FileList["lib/**/*rb"]

task :nongeminstall do
  prefix = File.join(destdir, sitelibdir)
  LIBS.each do |lib|
    dst = File.join(prefix, File.dirname(lib.sub(/\Alib\//,"")))
    mkdir_p dst
    install lib, dst, :mode => 0644
  end
end
