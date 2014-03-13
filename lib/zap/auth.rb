module Zap
    class Auth
        def initialize(params = {})
            @ctx = params[:context] || 1 #default context is the1
            @base = params[:base] || "http://127.0.0.1:8080/JSON"
        end

        def login_url
            RestClient::get "#{@base}/auth/view/loginUrl/?zapapiformat=JSON&contextId=#{@ctx}"
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
    end
end
