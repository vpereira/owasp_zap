require 'helper'

describe Zap::Auth do
    before do 
        @auth = Zap::Auth.new 
    end
    it "should have context 1" do
        assert_equal(@auth.ctx,1)
    end
    it "should have base on localhost" do 
        assert_equal @auth.base,"http://127.0.0.1:8080/JSON"
    end
end

describe "Auth view methods" do
     before do
         @h = Zap::Auth.new
         @methods = [:login_url, :logout_url, :login_data, :logout_data, :logged_in_indicator, :logged_out_indicator]
         @methods.each do |m|
            m_str = m.to_s
            m_str.extend Zap::StringExtension
            m_str = m_str.camel_case
            stub_request(:get, "http://127.0.0.1:8080/JSON/auth/view/#{m_str}/?zapapiformat=JSON&contextId=1").to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})
         end
     end

     it "should request all view methods" do
         @methods.each do |m|
            m_str = m.to_s
            m_str.extend Zap::StringExtension
            m_str = m_str.camel_case
            @h.send(m)
            assert_requested :get,"http://127.0.0.1:8080/JSON/auth/view/#{m_str}/?zapapiformat=JSON&contextId=1"
         end
     end
end

describe "Login/Logout" do
    before do 
        @h = Zap::Auth.new
            stub_request(:get, "http://127.0.0.1:8080/JSON/auth/action/logout/?zapapiformat=JSON&contextId=1").to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})
            stub_request(:get, "http://127.0.0.1:8080/JSON/auth/action/login/?zapapiformat=JSON&contextId=1").to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})
    end
    it "should call the login url" do
        @h.login
        assert_requested :get,"http://127.0.0.1:8080/JSON/auth/action/login/?zapapiformat=JSON&contextId=1"
    end
    it "should call the logout url" do
        @h.logout
        assert_requested :get,"http://127.0.0.1:8080/JSON/auth/action/logout/?zapapiformat=JSON&contextId=1"
    end
end
