# Conred

Conred stands for ConcepticHQ resuable and d in the end is added for awsomness

## Installation

Add this line to your application's Gemfile:

    gem 'conred'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install conred

## Usage

Right now (version 0.0.8) has several helpers and video class.
For video you can use:

    c = Conred::Video.new("http://www.youtube.com/watch?v=Lrj5Kxdzouc")
    
Then for embed code:
    
    c.code
    
You can also check if it is youtube video or vimeo video like this:

    c.youtube_video? ==> true
    c.vimeo_video? ==> false
Currently video feature works with Youtube and Vimeo URL's
    
If you wish to use text helpers then in your application_helper add this include line:

    include Conred::Helpers

Now you have these methods available to you:

Sanitizes all html and trims content if count is provided:
    
    sanitize_and_trim("<html>string with", 10) => "string ..."
    
Sanitizes body, allowed tags are(p a strong ul ol li blockquote strike u em):

    sanitize_body("<html><strong>string</strong> <p>with<p></html>") => "<strong>string</strong> <p>with<p>"
    
External link formating

    external_url("www.google.lv") => "http://www.google.lv"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
