# OwaspZap


## A ruby client to access the HTTP API from Zap Proxy (http://code.google.com/p/zaproxy)

## if you need a rpm, check it here: https://build.opensuse.org/package/show/home:vpereirabr/owasp-zap

[![Build Status](https://travis-ci.org/vpereira/owasp_zap.png?branch=master)](https://travis-ci.org/vpereira/owasp_zap)
[![Code Climate](https://codeclimate.com/github/vpereira/owasp_zap.png)](https://codeclimate.com/github/vpereira/owasp_zap)

## Installation

Add this line to your application's Gemfile:

    gem 'owasp_zap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install owasp_zap

## Usage

    require 'owasp_zap'
    
    include OwaspZap 

    z = Zap.new :target=>'http://xxx.xxx.xxx' #create new Zap instance with default params
    z = Zap.new :target=>'http://yyy.yyy.yyy', :zap=>"/usr/share/owasp-zap/zap.sh" #if you got my obs package
    z.start # start interactive
    # TODO
    # document it further :) 
    z.start :daemon=>true # start in daemon mode
    z.shutdown # stop the proxy

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
