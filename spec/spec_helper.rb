$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'search_tree'


# Minitest has a circular require somewhere in it. Suppress
oldv    = $VERBOSE
$VERBOSE=nil
require 'minitest/spec'
require 'minitest/autorun'
$VERBOSE=oldv


# Add for use within RubyMine
require 'minitest/reporters'
MiniTest::Reporters.use!

