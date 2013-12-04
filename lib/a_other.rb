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

def one_of_four_urls( url )
  urls = Array.new
  
  urls << "http://#{url}"
  urls << "#{url}"
  urls << "http://www.#{url}"
  urls << "www.#{url}"
  
  return urls.sample
end

def one_of_urls( url )
  urls = Array.new
  
  urls << "http://#{url}"
  urls << "#{url}"
  urls << "http://www.#{url}"
  urls << "www.#{url}"
  
  # same as above
  urls << "http://#{url}"
  urls << "#{url}"
  urls << "http://www.#{url}"
  urls << "www.#{url}"
  
  # with trailing slashes
  urls << "#{url}/"
  urls << "http://#{url}/"
  urls << "http://www.#{url}/"  
  urls << "www.#{url}/"
  
  return urls.sample
end


#def random_shifting( number )
#end