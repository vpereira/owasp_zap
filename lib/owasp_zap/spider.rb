module OwaspZap
    class Spider

        def initialize(params = {})
            #TODO
            #handle it
            @base = params[:base]
            @target = params[:target]
            @api_key = params[:api_key]
        end

        def start
            set_query "#{@base}/JSON/spider/action/scan/?apikey=#{@api_key}"
        end

        def spider_as_user(context_id, user_id, max_children = 1000)
            set_query "#{@base}/JSON/spider/action/scanAsUser/", contextId: context_id, userId: user_id, maxChildren: max_children
        end

        def stop
            RestClient::get "#{@base}/JSON/spider/action/stop/?zapapiformat=JSON&apikey=#{@api_key}"
        end

        def status
            ret = JSON.parse(RestClient::get("#{@base}/JSON/spider/view/status/?zapapiformat=JSON&apikey=#{@api_key}"))
            if ret.has_key? "status"
                ret["status"].to_i
            else
                100 # it means no running
            end
        end

        def running?
            self.status != 100
        end

        private

        def set_query(addr, params={})
            default_params = {:zapapiformat=>"JSON",:url=>@target, :apikey=>@api_key}
            url = Addressable::URI.parse addr
            url.query_values = default_params.merge params
            RestClient::get url.normalize.to_str
        end

    end
end
