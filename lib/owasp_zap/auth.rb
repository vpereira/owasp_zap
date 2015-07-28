module OwaspZap
    class Auth
        attr_accessor :ctx,:base
        def initialize(params = {})
            @ctx = params[:context] || 1 #default context is the1
            @base = params[:base] || "http://127.0.0.1:8080/JSON"
            @target = params[:target]
            @uid = nil
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
          response = eval(set_query "#{@base}/json/context/action/importContext/", contextFile: context)
          #TODO: Parse response from view context call to interpret context id... currently hard-coded
          @ctx = response[:contextId]
        end

        def new_context(context_name, set_as_context=true)
            response = eval(set_query "#{@base}/json/context/action/newContext/", contextName: context_name)
            @ctx = response[:contextId] if set_as_context
        end

        def set_include_in_context(context_name, regrexs)
            regrexs.each do |regrex|
                set_query "#{@base}/json/context/action/includeInContext/", contextName: context_name, regrex: regrex
            end 
        end

        def set_exclude_from_context(context_name, regrexs)
            regrexs.each do |regrex|
                set_query "#{@base}/json/context/action/excludeFromContext/", contextName: context_name, regrex: regrex
            end 
        end

        def new_user(name)
            response = eval(set_query "#{@base}/json/users/action/newUser/", contextId: @ctx, name: name)
            @uid = response[:userId]
        end

        def users(context)
            set_query "#{@base}/json/users/view/usersList", contextId: context
        end

        def contexts
            set_query "#{@base}/json/context/view/contextList/"
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
        def set_query(addr, params={})
            default_params = {:zapapiformat=>"JSON",:url=>@target,:contextId=>@ctx}
            url = Addressable::URI.parse addr
            url.query_values = params
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

