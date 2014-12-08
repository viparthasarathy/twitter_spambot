require 'jumpstart_auth'
require 'bitly'

Bitly.use_api_version_3

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
  end

  def shorten(original_url)
  	puts "Shortening this URL: #{original_url}"
  	bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
  	bitly.shorten(original_url).short_url
  end

  def tweet(message)
  	check = message.scan(/./)
  	if check.length > 140
  	  puts "Your message is too long. Try again."
  	else
  	  @client.update(message)
  	end
  end

  def followers_list
  	screen_names = []
  	@client.followers.each { |follower| screen_names << @client.user(follower).screen_name }
    screen_names
  end

  def spam_my_followers(message)
  	followers_list.each { |follower| dm(follower, message) }
  end

  def dm(target, message)
  	puts "Trying to send #{target} this direct message:"
  	puts message
  	message = "d @#{target} #{message}"
  	if followers_list.include? target
  	  tweet(message)
  	else
  	  puts "You can only direct message people who follow you."
  	end
  end

   
  def everyones_last_tweet
  	friends = @client.friends.sort_by { |friend| @client.user(friend).screen_name.downcase }
  	friends.each do |friend|
  	  timestamp = @client.user(friend).created_at
      puts "#{@client.user(friend).screen_name}, #{timestamp.strftime('%A, %b %d')}, says:"
      puts @client.user(friend).status.text
  	end
  end


  def run
  	puts "Welcome to the JSL Twitter Client!"
  	command = ""
  	while command != 'q'
  		printf "enter command: "
  		input = gets.chomp
  		parts = input.split(" ")
  		command = parts[0]

  		case command
  		when 'q' then puts "Goodbye!"
  		when 't' then tweet(parts[1..-1].join(" "))
  		when 'dm' then dm(parts[1], parts[2..-1].join(" "))
  		when 'spam' then spam_my_followers(parts[1..-1].join(" "))
  		when 'elt' then everyones_last_tweet
  		when 's' then shorten(parts[1..-1].join)
  		when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
  		else
  		  puts "Sorry, I don't know how to #{command}"
  		end
  	end
  end

end

  blogger = MicroBlogger.new
  blogger.run
