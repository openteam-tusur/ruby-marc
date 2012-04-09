$:.unshift  '../lib'
if RUBY_VERSION =~ /1\.8\./
  require 'rubygems'
end
require 'marc'
require 'benchmark'
require 'oj'
require 'yajl'

interp = 'MRI'
if defined? JRUBY_VERSION
  interp = 'JRuby'
end
platform = interp + ' ' + RUBY_VERSION
puts RUBY_DESCRIPTION
yp = Yajl::Parser.new
Benchmark.bm do |x|

unless defined? JRUBY_VERSION
  File.open('topics.ndj') do |f|
    x.report('%-30s' % "#{platform} yajl read") do
      f.each_line do |json|
        r = MARC::Record.new_from_hash(Yajl::Parser.parse json)
      end
    end
  end
end

  File.open('topics.ndj') do |f|
    x.report('%-30s' % "#{platform} oj read") do
      f.each_line do |json|
        r = MARC::Record.new_from_hash Oj.load json
      end
    end
  end

unless defined? JRUBY_VERSION
  reader = MARC::Reader.new('topics.mrc')
  File.open('yajl.json', 'w') do |f|
    x.report('%-30s' % "#{platform} yajl write") do
      reader.each do |r|
        f.puts Yajl::Encoder.encode r.to_hash
      end
    end
  end
end

  reader = MARC::Reader.new('topics.mrc')
  File.open('oj.json', 'w') do |f|
    x.report('%-30s' % "#{platform} oj write") do
      reader.each do |r|
        f.puts Oj.dump r.to_hash
      end
    end
  end
  
end
        