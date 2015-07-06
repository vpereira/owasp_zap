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
                100 # it means no running
          ""  end
        end

        def full_results(format = 'HTML', scan_id = 0)
            case format
                when "JSON"
                    JSON.parse(RestClient::get("#{@base}/JSON/spider/view/fullResults/?zapapiformat=JSON&scanId=#{scan_id}"))
                else
                    RestClient::get("#{@base}/#{format}/spider/view/fullResults/?zapapiformat=#{format}&scanId=#{scan_id}")
            end
        end

       def running?
            self.status != 100
       end
    end
end
