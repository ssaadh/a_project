require_relative 'rails-blank'

def text_file_touched
  File.exists? '../hi.ats'
end

def remove_touched_file
  File.delete '../hi.ats'
end

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
  
  if slash == true
    # with trailing slashes
    urls << "#{url}/"
    urls << "http://#{url}/"
    urls << "http://www.#{url}/"
    urls << "www.#{url}/"
  end
  
  return urls.sample
end


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

#def random_shifting( number )
#end