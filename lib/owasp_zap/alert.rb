module OwaspZap
    class Alert
        def initialize(params = {})
            #handle params
            @base = params[:base]
            @target = params[:target]
            @api_key = params[:api_key]
        end

        #
        # the API has an option to give an offset (start) and the amount of alerts (count) as parameter
        def view(format = "JSON")
            raise OwaspZap::WrongFormatException,"Output format not accepted" unless ["JSON","HTML","XML"].include?(format)
            #http://localhost:8080/JSON/core/view/alerts/?zapapiformat=JSON&baseurl=http%3A%2F%2F192.168.1.113&start=&count=
            url = Addressable::URI.parse "#{@base}/#{format}/core/view/alerts/"
            url.query_values = {:zapapiformat=>format,:baseurl=>@target, :apikey=>@api_key}
            str = RestClient::get url.normalize.to_str
            format == "JSON" ? JSON.parse(str)["alerts"] : str
        end
    end
end
