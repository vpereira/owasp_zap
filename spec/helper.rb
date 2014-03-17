require 'minitest/autorun'
require 'webmock/minitest'
require 'simplecov'
SimpleCov.command_name 'minitest'
SimpleCov.start
require File.expand_path('../../lib/zap', __FILE__)
require 'zap'
