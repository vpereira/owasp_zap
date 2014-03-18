module Zap
    class Auth
        attr_accessor :ctx,:base
        def initialize(params = {})
            @ctx = params[:context] || 1 #default context is the1
            @base = params[:base] || "http://127.0.0.1:8080/JSON"
        end

        #
        # define dynamically the methods from: http://127.0.0.1:8080/UI/auth/
        #
        #
        [:login_url, :logout_url, :login_data, :logout_data, :logged_in_indicator, :logged_out_indicator].each do |method|
            define_method method do
                RestClient::get "#{@base}/auth/view/#{to_url(method)}/?zapapiformat=JSON&contextId=#{@ctx}"
            end
        end

        #
        # define methods login, logout 
        #
        #
        [:login,:logout].each do |method|
            define_method method do
               RestClient::get "#{@base}/auth/action/#{to_url(method)}/?zapapiformat=JSON&contextId=#{@ctx}"
            end
        end

        # params:
        # args a hash with the following keys -> values
        # url: url including http:// 
        # post_data: an already encoded string like "email%3Dfoo%2540example.org%26passwd%3Dfoobar" 
        # TODO: offer a way to encode it, giving a hash?
        def set_login_url(args)
            url = Addressable::URI.parse "#{@base}/auth/action/setLoginUrl/"
            url.query_values = {:zapapiformat=>"JSON",:url=>args[:url],:postData=>args[:post_data],:contextId=>@ctx}
            RestClient::get url.normalize.to_str
        end

        def set_logout_url(args)
            url = Addressable::URI.parse "#{@base}/auth/action/setLogoutUrl/"
            url.query_values = {:zapapiformat=>"JSON",:url=>args[:url],:postData=>args[:post_data],:contextId=>@ctx}
            RestClient::get url.normalize.to_str
        end

        def set_logged_in_indicator(args)
            url = Addressable::URI.parse "#{@base}/auth/action/setLoggedInIndicator/"
            url.query_values = {:zapapiformat=>"JSON",:url=>args[:url],:postData=>args[:indicator],:contextId=>@ctx}
            RestClient::get url.normalize.to_str
        end

        def set_logged_out_indicator(args)
            url = Addressable::URI.parse "#{@base}/auth/action/setLoggedOutIndicator/"
            url.query_values = {:zapapiformat=>"JSON",:url=>args[:url],:indicator=>args[:indicator],:contextId=>@ctx}
            RestClient::get url.normalize.to_str
        end

        private
        def to_url(str)
            method_str = str.to_s
            method_str.extend Zap::StringExtension # monkey patch just this instance
            method_str.camel_case
         end

        def to_method(str)
            method_str = str.to_s
            method_str.extend Zap::StringExtension # monkey patch just this instance
            method_str.snake_case
        end
    end
end
