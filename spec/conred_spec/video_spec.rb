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
    let(:vimeo_channel_url) {Conred::Video.new(:video_url=>"https://vimeo.com/channels/staffpicks/107469289")}
    let(:evil_vimeo) {Conred::Video.new(:video_url=>"eeevil vimeo www.vimeo.com/12311233")}
    let(:vimeo_without_http) {Conred::Video.new(:video_url=>"vimeo.com/12311233")}

    let(:error_video) { Conred::Video.new(
                          :video_url => "http://google.com/12311233",
                        :error_message => "Some mistake in url")
                        }

    it "should match youtube video" do
      expect(short_youtube_url).to be_youtube_video
      expect(https_youtube_url).to be_youtube_video
      expect(short_youtube_url_with_www).to be_youtube_video
      expect(long_youtube_url_with_features).to be_youtube_video
      expect(short_youtube_url_without_http_and_www).to be_youtube_video
    end

    it "should check for corner cases" do
      expect(evil_vimeo).to_not be_youtube_video
      expect(evil_vimeo).to_not be_vimeo_video
    end

    it "should match vimeo video" do
      expect(vimeo_url).to_not be_youtube_video
      expect(vimeo_without_http).to be_vimeo_video
      expect(https_vimeo_url).to be_vimeo_video
      expect(vimeo_url).to be_vimeo_video
      expect(vimeo_channel_url).to be_vimeo_video
    end

    describe "youtube embed code" do
      subject {Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzouc", :width=>450,:height=> 300).code }
      it "matches to correct html" do
        expect(subject).to match(/Lrj5Kxdzouc/)
        expect(subject).to match(/width="450"/)
        expect(subject).to match(/height="300"/)
      end
    end

    describe "vimeo embed code" do
      subject { Conred::Video.new(:video_url=>"http://vimeo.com/49556689", :width=>450, :height=>300).code }
      it "matches to correct html" do
        expect(subject).to match(/49556689/)
        expect(subject).to match(/width="450"/)
        expect(subject).to match(/height="300"/)
      end
    end

    it "should render error message when url is invalid" do
      expect(error_video.code).to eq("Some mistake in url")
    end

    it "should return correct embed code when passing arguments in url" do
      expect(Conred::Video.new(:video_url=>"http://www.youtube.com/watch?NR=1&feature=endscreen&v=Lrj5Kxdzouc",:width=> 450,:height=> 300).code).to match(/Lrj5Kxdzouc/)
    end

    describe "check if a video exist" do
      it "should return false if request 404" do
          non_existing_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzoux")
        expect(non_existing_video.exist?).to eq(false)
      end

      it "should make a request to the proper youtube uri" do
        non_existing_youtube_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzoux")
        expect(non_existing_youtube_video.api_uri).to eq("//www.youtube.com/oembed?format=json&url=https://www.youtube.com/watch?v=Lrj5Kxdzoux")
      end

      it "should make a request to the proper vimeo uri" do
        non_existing_vimeo_video = Conred::Video.new(:video_url=>"http://vimeo.com/49556689")
        expect(non_existing_vimeo_video.api_uri).to eq("//vimeo.com/api/v2/video/49556689.json")
      end

      it "should be true if response is 200" do
        existing_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzouc")
        expect(existing_video.exist?).to eq(true)
      end

      it "should be false if uri isn't recognized" do
        expect(error_video.exist?).to eq(false)
      end
    end

    describe "view count check" do
      it "should render the view count of an existing youtube video" do
        existing_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzouc")
        expect(existing_video.view_count.is_a? Integer).to eq(true)
        expect(existing_video.view_count).to be > 2000000
      end

      it "should return nil for the view count for a non existing youtube video" do
        non_existing_video = Conred::Video.new(:video_url=>"http://www.youtube.com/watch?v=Lrj5Kxdzoux")
        expect(non_existing_video.view_count).to eq(nil)
      end

      it "should render the view count of an existing vimeo video" do
        existing_video = Conred::Video.new(:video_url=>"http://vimeo.com/87701971")
        expect(existing_video.view_count.is_a? Integer).to eq(true)
        expect(existing_video.view_count).to be > 1900000
      end

      it "should return nil for the view count for a non existing vimeo video" do
        non_existing_video = Conred::Video.new(:video_url=>"http://vimeo.com/877019718976876")
        expect(non_existing_video.view_count).to eq(nil)
      end
    end
  end
end
