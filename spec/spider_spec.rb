describe OwaspZap::Spider do
    before do
        @spider = OwaspZap::Spider.new :base=>"http://127.0.0.1:8080",:target=>"http://example.org"
    end
    it "should not be_nil" do
        refute @spider.nil?
    end
    it "should respond_to running?" do
        @spider.must_respond_to :running?
    end
    it "should be running if status != 100" do
      @spider.stub(:status,95) do
        @spider.running?.must_equal true
      end
    end

    it "should not be running if status == 100" do
      @spider.stub(:status,100) do
        @spider.running?.must_equal false
      end
    end

    it "should set depth" do
      stub_request(:get, "http://127.0.0.1:8080/JSON/spider/action/setOptionMaxDepth/?integer=1").
        to_return(:status => 200, :body => "{\"Result\":\"OK\"}", :headers => {})
      @spider.set_depth(1).wont_be_nil
    end

    it "should get depth" do
      stub_request(:get, "http://127.0.0.1:8080/JSON/spider/view/status/?zapapiformat=JSON").
        to_return(:status => 200, :body => "{\"MaxDepth\":\"2\"}", :headers => {})
      @spider.depth.wont_be_nil
    end
end
