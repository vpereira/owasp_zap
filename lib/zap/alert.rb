module Zap
    class Alert
        def initialize(params = {})
            #handle params
            @base = params[:base]
            @target = params[:target]
        end

        #
        # the API has an option to give an offset (start) and the amount of alerts (count) as parameter
        def view
            #http://localhost:8080/JSON/core/view/alerts/?zapapiformat=JSON&baseurl=http%3A%2F%2F192.168.1.113&start=&count=
            url = Addressable::URI.parse "#{@base}/core/view/alerts/"
            url.query_values = {:zapapiformat=>"JSON",:baseurl=>@target}
            RestClient::get(url.normalize.to_str)
        end
    end
end
