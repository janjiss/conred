require "conred"

describe Conred do
  describe Conred::Video do

    let(:short_youtube_url) {Conred::Video.new(:video_url=>"http://youtu.be/SZt5RFzqEfY")}
    let(:https_youtube_url) {Conred::Video.new(:video_url=>"https://youtu.be/SZt5RFzqEfY")}
    let(:short_youtube_url_with_www) {Conred::Video.new(:video_url=>"www.youtu.be/SZt5RFzqEfY")}
    let(:long_youtube_url_with_features) {Conred::Video.new(:video_url=>"http://www.youtube.com/watch?NR=1&feature=endscreen&v=Lrj5Kxdzouc")}
    let(:short_youtube_url_without_http_and_www) {Conred::Video.new(:video_url=>"youtu.be/SZt5RFzqEfY")}

    let(:vimeo_url) {Conred::Video.new(:video_url=>"http://vimeo.com/12311233")}
    let(:https_vimeo_url) {Conred::Video.new(:video_url=>"http://vimeo.com/12311233")}
    let(:evil_vimeo) {Conred::Video.new(:video_url=>"eeevil vimeo www.vimeo.com/12311233")}
    let(:vimeo_without_http) {Conred::Video.new(:video_url=>"vimeo.com/12311233")}
    
    it "should match youtube video" do
      short_youtube_url.should be_youtube_video
      https_youtube_url.should be_youtube_video
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
      https_vimeo_url.should be_vimeo_video
      vimeo_url.should be_vimeo_video
    end  

    describe "youtube embed code" do
      subject {Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzouc", :width=>450,:height=> 300).code }
      it { should match(/Lrj5Kxdzouc/)}
      it { should match(/width='450'/)}
      it {should match(/height='300'/)} 
    end

    describe "vimeo embed code" do
      subject { Conred::Video.new(:video_url=>"http://vimeo.com/49556689", :width=>450, :height=>300).code }
      it {should match(/49556689/)}
      it {should match(/width='450'/)}
      it {should match(/height='300'/)}
    end

    it "should render error message when url is invalid" do
      Conred::Video.new(:video_url=>"http://google.com/12311233", :width=>450, :height=>300, :error_message=>"Some mistake in url").code.should == "Some mistake in url"
    end

    it "should return correct embed code when passing arguments in url" do
      Conred::Video.new(:video_url=>"http://www.youtube.com/watch?NR=1&feature=endscreen&v=Lrj5Kxdzouc",:width=> 450,:height=> 300).code.should match(/Lrj5Kxdzouc/)
    end

    describe "check if a video exist" do
      it "should return false if request 404" do
        non_existing_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzoux")
        Net::HTTP.stub(:get_response=>Net::HTTPNotFound.new(true, 404, "Not Found"))
        non_existing_video.exist?.should be_false
      end

      it "should make a request to the proper uri" do
        non_existing_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzoux")
        non_existing_video.api_uri.should eq("//gdata.youtube.com/feeds/api/videos/Lrj5Kxdzoux")
      end

      it "should be true if response is 200" do
        existing_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzouc")
        Net::HTTP.stub(:get_response=>Net::HTTPOK.new(true,200,"OK"))
        existing_video.exist?.should be_true
      end
    end
  end
end
