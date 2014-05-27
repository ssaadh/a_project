require_relative 'rails-blank'

##
## Text file and checking
##

def text_file_touch?
  # Check for file existing every three seconds. Doing sleep stops the thread/script which is a problem?
  now = Time.now
  counter = 1
  loop do
    if Time.now < now + counter
      return true if File.exists? '../hi.ats'
    end
    counter += 3
  end
end

def text_file_touched?
  remove_touched_file
  loop do
    return true if File.exists? "#{ File.dirname( __FILE__ ) }/../hi.ats"
    sleep 3
  end
end

def remove_touched_file
  the_file = "#{ File.dirname( __FILE__ ) }/../hi.ats"
  File.delete the_file if File.exists? the_file
end

##
## Picking random line from text file
##

# from http://stackoverflow.com/questions/11007111/ruby-whats-an-elegant-way-to-pick-a-random-line-from-a-text-file/11007320#11007320
def pick_random_line( the_file )
  chosen_line = nil
  File.foreach( the_file ).each_with_index do | line, number |
    chosen_line = line if rand < 1.0/(number+1)
  end
  return chosen_line
end

def pick_random_line_in_memory( the_file )
  File.readlines( the_file ).sample
end

##
## Probabilities - url choosing
##

def one_of_urls( url, www: true, slash: true )
  # repeat the non slash ones twice for greater probability of getting them
  
  urls = Array.new
  
  urls << "http://#{url}"
  urls << "#{url}"  
  # same as above
  urls << "http://#{url}"
  urls << "#{url}"
  
  if www == true
    urls << "http://www.#{url}"
    urls << "www.#{url}"
    # same as above
    urls << "http://www.#{url}"
    urls << "www.#{url}"
  end
  
  # trailing slashes
  if slash == true
    urls << "#{url}/"
    urls << "http://#{url}/"
  end
  
  if slash == true && www == true
    urls << "http://www.#{url}/"
    urls << "www.#{url}/"
  end
  
  return urls.sample
end

##
## Probabilities - quick, dirty shortcuts
##

def half_or_half
  if 1 == rand( 1..2 )
    return true
  else
    return false
  end
end

def half_and_half
  half_or_half
end

def one_third
  if 1 == rand( 1..3 )
    return true
  else
    return false
  end
end

def one_fourth
  if 1 == rand( 1..4 )
    return true
  else
    return false
  end
end

##
## Randomness
##

def small_random_sleep( range = 1..2 )
  number = rand( range )
  sleep number
end

def medium_random_sleep( range = 3..5 )
  number = rand( range )
  sleep number
end
