require "conred"

describe Conred do
  describe Conred::Video do
    before do
      @vimeo_embed_code = <<-eos
      <iframe
        id='vimeo_video'
        src='http://player.vimeo.com/video/49556689'
        width='450'
        height='300'
        frameborder='0'
        webkitAllowFullScreen
        mozallowfullscreen
        allowFullScreen>
      </iframe>
      eos

      @youtube_embed_code = 
      <<-eos
      <iframe
        id='youtube_video'
        title='YouTube video player'
        width='450'
        height='300'
        src='http://www.youtube.com/embed/Lrj5Kxdzouc?wmode=transparent'
        frameborder='0'
        allowfullscreen>
      </iframe>
      eos


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