require 'simplecov'
SimpleCov.start
SimpleCov.add_filter '/spec/'
require 'minitest/autorun'
require 'webmock/minitest'
#SimpleCov.command_name 'minitest'
require File.expand_path('../../lib/owasp_zap', __FILE__)
require 'owasp_zap'
