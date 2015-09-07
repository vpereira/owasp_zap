module OwaspZap
    class Spider

        def initialize(params = {})
            #TODO
            #handle it
            @base = params[:base]
            @target = params[:target]
        end

        def start
            #http://localhost:8080/JSON/spider/action/scan/?zapapiformat=JSON&url=
            url = Addressable::URI.parse "#{@base}/JSON/spider/action/scan/"
            url.query_values = {:zapapiformat=>"JSON",:url=>@target}
            RestClient::get url.normalize.to_str
        end

        def stop
            RestClient::get "#{@base}/JSON/spider/action/stop/?zapapiformat=JSON"
        end

        def status
            ret = JSON.parse(RestClient::get("#{@base}/JSON/spider/view/status/?zapapiformat=JSON"))
            if ret.has_key? "status"
                ret["status"].to_i
            else
                100 # it means not running
            end
       end

       def set_depth(max_d)
            #http://localhost:8084/JSON/spider/action/setOptionMaxDepth/?Integer=1
            url = Addressable::URI.parse("#{@base}/JSON/spider/action/setOptionMaxDepth/")
            url.query_values = {:integer=>max_d.to_i}
            RestClient::get url.normalize.to_str
       end

       def depth
            JSON.parse(RestClient::get("#{@base}/JSON/spider/view/status/?zapapiformat=JSON"))
       end

       def running?
            self.status != 100
       end
    end
end
