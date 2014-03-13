module Zap
    class Auth
        attr_accessor :login_url, :login_data, :loggedin_indicator, :logout_url, :logout_data, :loggedout_indicator
        def initialize(params = {}
            @ctx = params[:context] || 1 #default context is the1
            @base = params[:base] || "http://127.0.0.1:8080/JSON"
        end

        def login_url
            RestClient::get "#{@base}/auth/view/loginUrl/?zapapiformat=JSON&contextId=#{@ctx}"
        end
        
        # params
        # url: url including http:// 
        # post_data: an already encoded string like "email%3Dfoo%2540example.org%26passwd%3Dfoobar" 
        # TODO: offer a way to encode it, giving a hash?
        def login_url=(url,post_data)
            url = Addressable::URI.parse "#{@base}/auth/action/setLoginUrl/"
            url.query_values = {:zapapiformat=>"JSON",:url=>@target,:postData=@post_data,:contextID=>@ctx}
            RestClient::get url.normalize.to_str
        end
    end
end
