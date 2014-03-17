module Zap
    class Auth
        attr_accessor :ctx
        def initialize(params = {})
            @ctx = params[:context] || 1 #default context is the1
            @base = params[:base] || "http://127.0.0.1:8080/JSON"
        end

        def login_url
            RestClient::get "#{@base}/auth/view/loginUrl/?zapapiformat=JSON&contextId=#{@ctx}"
        end
        
        def login_data
            RestClient::get "#{@base}/auth/view/loginData/?zapapiformat=JSON&contextId=#{@ctx}"
        end

        def logged_in_indicator
            RestClient::get "#{@base}/auth/view/loggedInIndicator/?zapapiformat=JSON&contextId=#{@ctx}"
        end

        def logout_url
            RestClient::get "#{@base}/auth/view/logoutUrl/?zapapiformat=JSON&contextId=#{@ctx}"
        end

        def logout_data
            RestClient::get "#{@base}/auth/view/logoutData/?zapapiformat=JSON&contextId=#{@ctx}"
        end

        def login
            RestClient::get "#{@base}/auth/action/login/?zapapiformat=JSON&contextId=#{@ctx}"
        end

        def logout
            RestClient "#{@base}/auth/action/logout/?zapapiformat=JSON&contextId=#{@ctx}"
        end
    
        def logged_out_indicator
            RestClient "#{@base}/auth/view/loggedOutIndicator/?zapapiformat=JSON&contextId=#{@ctx}"
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
    end
end
