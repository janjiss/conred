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
    it "should match youtube video" do
      Conred::Video.new("http://www.youtube.com/watch?v=SZt5RFzqEfY&feature=g-all-fbc").should be_youtube_video
      Conred::Video.new("http://youtu.be/SZt5RFzqEfY").should be_youtube_video
      Conred::Video.new("youtu.be/SZt5RFzqEfY").should be_youtube_video
      Conred::Video.new("youtube.com/watch?v=SZt5RFzqEfY&feature=g-all-fbc").should be_youtube_video
      Conred::Video.new("www.youtube.com/watch?v=SZt5RFzqEfY&feature=g-all-fbc").should be_youtube_video
      Conred::Video.new("www.youtu.be/SZt5RFzqEfY").should be_youtube_video
      Conred::Video.new("youtube.com/watch?v=SZt5RFzqEfY&feature=g-all-fbc").should be_youtube_video
      Conred::Video.new("www.youtube.com/watch?v=SZt5RFzqEfY&feature=g-all-fbc").should be_youtube_video
      Conred::Video.new("www.youtu.be/SZt5RFzqEfY").should be_youtube_video
    end
    it "should match vimeo video" do
      Conred::Video.new("http://vimeo.com/12311233").youtube_video? == false
      Conred::Video.new("vimeo.com/12311233").youtube_video? == false
      Conred::Video.new("http://www.vimeo.com/12311233http://youtube.com/12311233").youtube_video? == false
      Conred::Video.new("eeevil vimeo www.vimeo.com/12311233").youtube_video? == false
    end  
    # it "should not match any video video" do
    #   Conred::Video.new("http://youtube.com/12311233").should not_be_vimeo_video
    #   Conred::Video.new("ftp://vimeo.com/12311233").should not_be_vimeo_video
    #   Conred::Video.new("http://www.youtube.com/watch?vimeo.com/12311233").should not_be_vimeo_video
    #   Conred::Video.new("evil string http://vimeo.com/12311233").should not_be_vimeo_video
    # end
  end

  describe Conred::Links do

  end

end