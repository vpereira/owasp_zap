module Zap
    class Spider

        def initialize(params = {})
            #TODO
            #handle it
            @base = params[:base]
            @target = params[:target]
        end

        def start
            #http://localhost:8080/JSON/spider/action/scan/?zapapiformat=JSON&url=
            url = Addressable::URI.parse "#{@base}/spider/action/scan/"
            url.query_values = {:zapapiformat=>"JSON",:url=>@target}
            RestClient::get url.normalize.to_str
         end

        def status
            RestClient::get "#{@base}/spider/view/status/?zapapiformat=JSON")
        end
    end
end
