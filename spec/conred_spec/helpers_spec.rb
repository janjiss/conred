require "conred"

describe Conred do
  describe Conred::Helpers do

    before do
      @html_text = "<html><p>Paragraph text</p> <a href='http://google.com'>Link to some site</a></html>"
    end

    it "should return cleaned out text from html" do
      Conred::Helpers.sanitize_and_trim(@html_text).should == "Paragraph text Link to some site"
    end

    it "should truncate string to fourteen symbols" do
      Conred::Helpers.sanitize_and_trim(@html_text, 14).should == "Paragraph t..."
    end

    it "should use different truncate text at the ending of the line" do
      Conred::Helpers.sanitize_and_trim(@html_text, 11, "").should == "Paragraph t"
    end

    it "should remove unallowed tags" do
      Conred::Helpers.sanitize_body(@html_text).should == "<p>Paragraph text</p> <a href=\"http://google.com\">Link to some site</a>"
    end

    it "should add protocols in front of urls" do
      Conred::Helpers.external_url("http://www.google.lv").should == "http://www.google.lv"
      Conred::Helpers.external_url("www.google.lv").should == "http://www.google.lv"
    end 
  end
end