module OwaspZap
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
        def import_context(context)
          set_query "{@base}/context/action/importContext/",postData: context
          # contexts = RestClient::get "{@base}/context/view/contextList"
          # puts contexts
        end

        def contexts
            url = Addressable::URI.parse "{@base}/context/view/contextList"
            url.query_values = {:zapapiformat=>"JSON", :url=>"127.0.0.1"}
            c = RestClient::get url.normalize.to_s
            puts c
        end

        def set_login_url(args)
            set_query "#{@base}/auth/action/setLoginUrl/",:postData=>args[:post_data]
        end

        def set_logout_url(args)
            set_query "#{@base}/auth/action/setLogoutUrl/",:postData=>args[:post_data]
        end

        def set_logged_in_indicator(args)
            set_query "#{@base}/auth/action/setLoggedInIndicator/",:postData=>args[:indicator]
        end

        def set_logged_out_indicator(args)
            set_query "#{@base}/auth/action/setLoggedOutIndicator/", :indicator=>args[:indicator]
        end

        private

        # addr a string like #{@base}/auth/foo/bar
        # params a hash with custom params that should be added to the query_values
        def set_query(addr, params)
            default_params = {:zapapiformat=>"JSON",:url=>args[:url],:contextId=>@ctx}
            url Addressable::URI.parse addr
            url.query_values = default_params.merge(params)
            RestClient::get url.normalize.to_str
        end
        def to_url(str)
            method_str = str.to_s
            method_str.extend OwaspZap::StringExtension # monkey patch just this instance
            method_str.camel_case
         end

        def to_method(str)
            method_str = str.to_s
            method_str.extend OwaspZap::StringExtension # monkey patch just this instance
            method_str.snake_case
        end
    end
end

