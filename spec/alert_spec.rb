require 'helper'

describe OwaspZap::Alert do
    before do
        @alert = OwaspZap::Alert.new
    end
    it "should not be_nil" do
        refute @alert.nil?
    end
    it "should respond_to view" do
        assert_respond_to @alert, :view
    end

    it "should try WrongFormatException" do
        assert_raises(OwaspZap::WrongFormatException) { @alert.view("FOO") }
    end

    it "view accept HTML, JSON and XML as param" do
        ["JSON","HTML","XML"].each do |f|
            assert_raises(WebMock::NetConnectNotAllowedError) { @alert.view(format=f) }
        end
    end
end
