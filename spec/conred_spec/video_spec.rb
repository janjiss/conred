require "conred"

describe Conred do
  describe Conred::Video do
    before do

      @vimeo_code = "49556689"
      vimeo_file = File.join(
        File.dirname(__FILE__),
        '..', '..', 'lib', 'views',
        'video', 'vimeo_iframe.html.haml'
      )
      @vimeo_embed_code = Conred.render_file(vimeo_file).html_safe

      @youtube_id = "Lrj5Kxdzouc"
      youtube_file = File.join(
        File.dirname(__FILE__),
        '..', '..', 'lib', 'views',
        'video', 'youtube_iframe.html.haml'
      )
      @youtube_embed_code = Conred.render_file(youtube_file).html_safe
      
    end
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
    it "should return correct embed code" do
      Conred::Video.new("http://www.youtube.com/watch?NR=1&feature=endscreen&v=Lrj5Kxdzouc", 450, 300).code.should == @youtube_embed_code
      Conred::Video.new("http://www.youtube.com/watch?v=Lrj5Kxdzouc", 450, 300).code.should == @youtube_embed_code
      Conred::Video.new("http://vimeo.com/49556689", 450, 300).code.should == @vimeo_embed_code
      Conred::Video.new("http://google.com/12311233", 450, 300, "Some mistake in url").code.should == "Some mistake in url"
    end
  end
end