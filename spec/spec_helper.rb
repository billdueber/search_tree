$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'search_tree'


require 'minitest/spec'
require 'minitest/autorun'


# Add for use within RubyMine
require 'minitest/reporters'
if ENV['RM_INFO'] =~ /\S/
  puts "RUNNING UNDER RUBYMINE"
  MiniTest::Reporters.use!
else
  # MiniTest::Reporters.use! [Minitest::Reporters::SpecReporter.new(color: true)]
end


