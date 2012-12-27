require "conred"

describe Conred do
  describe Conred::Video do

    let(:short_youtube_url) {Conred::Video.new("http://youtu.be/SZt5RFzqEfY")}
    let(:short_youtube_url_with_www) {Conred::Video.new("www.youtu.be/SZt5RFzqEfY")}
    let(:long_youtube_url_with_features) {Conred::Video.new("http://www.youtube.com/watch?NR=1&feature=endscreen&v=Lrj5Kxdzouc")}
    let(:short_youtube_url_without_http_and_www) {Conred::Video.new("youtu.be/SZt5RFzqEfY")}

    let(:vimeo_url) {Conred::Video.new("http://vimeo.com/12311233")}
    let(:evil_vimeo) {Conred::Video.new("eeevil vimeo www.vimeo.com/12311233")}
    let(:vimeo_without_http) {Conred::Video.new("vimeo.com/12311233")}
    
    it "should match youtube video" do
      short_youtube_url.should be_youtube_video
      short_youtube_url_with_www.should be_youtube_video
      long_youtube_url_with_features.should be_youtube_video
      short_youtube_url_without_http_and_www.should be_youtube_video
    end

    it "should check for corner cases" do
      evil_vimeo.should_not be_youtube_video
      evil_vimeo.should_not be_vimeo_video
    end

    it "should match vimeo video" do
      vimeo_url.should_not be_youtube_video
      vimeo_without_http.should be_vimeo_video
      vimeo_url.should be_vimeo_video
    end  

    it "should return correct embed code" do
      Conred::Video.new("http://www.youtube.com/watch?NR=1&feature=endscreen&v=Lrj5Kxdzouc", 450, 300).code.should match(/Lrj5Kxdzouc/)
      Conred::Video.new("http://www.youtube.com/watch?v=Lrj5Kxdzouc", 450, 300).code.should match(/Lrj5Kxdzouc/)
      Conred::Video.new("http://www.youtube.com/watch?v=Lrj5Kxdzouc", 450, 300).code.should match(/width='450'/)
      Conred::Video.new("http://www.youtube.com/watch?v=Lrj5Kxdzouc", 450, 300).code.should match(/height='300'/)
      Conred::Video.new("http://vimeo.com/49556689", 450, 300).code.should match(/49556689/)
      Conred::Video.new("http://vimeo.com/49556689", 450, 300).code.should match(/width='450'/)
      Conred::Video.new("http://vimeo.com/49556689", 450, 300).code.should match(/height='300'/)
      Conred::Video.new("http://google.com/12311233", 450, 300, "Some mistake in url").code.should == "Some mistake in url"
    end
  end
end