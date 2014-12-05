require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
  	check = message.scan(/./)
  	if check.length > 140
  	  puts "Your message is too long. Try again."
  	else
  	  @client.update(message)
  	end
  end

  def dm(target, message)
  	puts "Trying to send #{target} this direct message:"
  	puts message
  	message = "d @#{target} #{message}"
  	screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name }
  	if screen_names.includes? target
  	  tweet(message)
  	else
  	  puts "You can only direct message people who follow you."
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
  		else
  		  puts "Sorry, I don't know how to #{command}"
  		end
  	end
  end

end

  blogger = MicroBlogger.new
  blogger.run
