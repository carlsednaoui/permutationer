# enable ruby gems on app
require 'rubygems'
require 'bundler'

Bundler.require

# load permutationer.rb and run app
require File.dirname(__FILE__) + "/permutationer.rb"

run Permutationer.new