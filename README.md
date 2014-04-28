[![Code Climate](https://codeclimate.com/github/janjiss/conred.png)](https://codeclimate.com/github/janjiss/conred)
[![Build Status](https://travis-ci.org/janjiss/conred.png?branch=master)](https://travis-ci.org/janjiss/conred)

# Conred

Easily and safely embed YouTube and Vimeo videos in your applications.

## Installation

Add this line to your application's Gemfile:

    gem 'conred'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install conred

## Usage

```ruby
c = Conred::Video.new(
  video_url: "http://www.youtube.com/watch?v=tNtW9pGFPTA&feature=plcp", 
  width: 285, 
  height: 185,
  error_message: "Video url is invalid"
)
```

Then you can get your ready embed code like this (Conred will recognize video provider by itself):

```ruby
c.code
```
    
You can also check if it is youtube or vimeo video like this:

```ruby
c.youtube_video? ==> true
c.vimeo_video? ==> false
```
    
Or if it exists:

```ruby
c.exists? ==> true
```

## Contributing

1. Fork it
2. Write your feature
3. Create tests for it (Important!)
4. Create new Pull Request
5. Be happy

## Thank you's

Please stand up from your chair and applaud to these guys: https://github.com/janjiss/conred/graphs/contributors
