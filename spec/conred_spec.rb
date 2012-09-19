require "conred"

describe Conred do
  describe Conred::Helpers do

    before do
      @html_text = "<p>Evil string</p> <a href='http://evilsite.com'>Link to some evil site</a>"
    end

    it "should return cleaned out text from html" do
      Conred::Helpers.sanitize_and_trim(@html_text).should == "Evil string Link to some evil site"
    end

    it "should truncate string to fourteen symbols" do
      Conred::Helpers.sanitize_and_trim(@html_text, 14).should == "Evil string..."
    end

    it "should use different truncate text at the ending of the line" do
      Conred::Helpers.sanitize_and_trim(@html_text, 11, "").should == "Evil string"
    end
  end

  describe Conred::Video do

  end

  describe Conred::Links do

  end
  
end