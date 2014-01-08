class DateOfBirthSpecifics
  attr_reader :yyyy, :yy, :year, :month, :mont_abbr, :month_number, :month_filled, :day, :day_filled
  
  def initialize( random_birthday )
    # Year
    @yyyy = random_birthday.year.to_s
    @yy = @birth_yyyy.to_s[ 2..-1 ]
    @year = @yyyy #alias/default
  
    # Numerical Day
    @day = random_birthday.day.to_s
    if @day.to_i < 10
      @day_filled = "0#{@day}"
    else
      @day_filled = @day
    end
  
    # Month
    @month_number = random_birthday.month.to_s
    if @month_number.to_i < 10
      @month_filled = "0#{@month_number}"
    else
      @month_filled = @month_number
    end    
    @month = Date::MONTHNAMES[ @month_number.to_i ]
    @month_abbr = Date::ABBR_MONTHNAMES[ @month_number.to_i ]
  end
end

#if you don't use @last right now, then that means the generate class can/will get funky if used more than once as an instance. fine for now.

require 'Forgery'

class Generate
  attr_reader :gender, :first_name, :last_name, :age
  attr_reader :date_of_birth
  attr_reader :birth_yyyy, :birth_yy, :birth_year, :month, :mont_abbr, :month_number, :month_filled, :day, :day_filled
  attr_reader :zip_code, :username, :password, :about
  attr_reader :phrase_one, :phrase_two
  
  def initialize
    
    ##
    # Gender
    ##
    if rand( 1..2 ) == 2
      @gender = 'female'
      @gender_single = 'f'
    else
      @gender = 'male'
      @gender_single = 'm'
    end
    
    
    ##
    # Age, Birth Date
    ##
    minimum_age = 19
    maximum_age = 50
    
    epoch_now = Time.now.to_i
    seconds_in_a_year = 60 * 60 * 24 * 365.25
    birth_date_minimum = epoch_now - seconds_in_a_year * minimum_age
    birth_date_maximum = epoch_now - seconds_in_a_year * maximum_age
    
    random_birthday = Time.at( rand( birth_date_maximum..birth_date_minimum ) )
    
    @date_of_birth = random_birthday
    
    # Year
    @birth_yyyy = random_birthday.year.to_s
    @birth_yy = @birth_yyyy.to_s[ 2..-1 ]
    @birth_year = @birth_yyyy #alias/default
    
    # Numerical Day
    @day = random_birthday.day.to_s
    if @day.to_i < 10
      @day_filled = "0#{@day}"
    else
      @day_filled = @day
    end
    
    # Month
    @month_number = random_birthday.month.to_s
    if @month_number.to_i < 10
      @month_filled = "0#{@month_number}"
    else
      @month_filled = @month_number
    end    
    @month = Date::MONTHNAMES[ @month_number.to_i ]
    @month_abbr = Date::ABBR_MONTHNAMES[ @month_number.to_i ]
    
    
    ##
    # Name
    ##
    
    # First name
    if @gender == 'male'
      @first_name = Forgery( :name ).male_first_name
    else
      @first_name = Forgery( :name ).female_first_name
    end
    
    # Last name
    @last_name = Forgery( :name ).last_name
    
    
    ##
    # Location
    ##
    
    # Zip code
    @zip_code = pick_random_line_in_memory( "#{ File.dirname( __FILE__ ) }/../data/nj_zip_codes.txt" )
    
    
    ##
    # Account
    ##
    
    # Username
    @username = 'overandaboutt' + rand( 99 ).to_s
    
    # Password
    @password = Forgery( :basic ).password :at_least => 8
    
    
    ##
    # Security phrase answers
    ##
    
    @phrase_one = 'that would be correct sir'
    @phrase_two = 'no i dont know'
    
    
    ##
    # Content
    ##
    
    @about = 'Hello everyone. I\'m just your regular old person...not too good with computers, but trying to get out there and try out new things like blogging. Hope to see your around!'    
  end
end

def email
  idontknow = 'lizzymanner.s@gmail.com'
end

class Imacros
  attr_accessor :code
  
  def initialize( browser )
    @browser = browser
    @code = ''
  end
  
  def ondownload( folder = '', file = '' )
    @code += "ONDOWNLOAD FOLDER=#{folder} FILE=#{file}" + "\n"
    self
  end
  
  ## type
  
  def img( attr1, attr2 = '*' )
    @code += "TAG POS=1 " + "TYPE=img " + "ATTR=#{attr1}:#{attr2} "
    self
  end
  
  ## set/content
  
  def content( specific = '' )
    @code += "CONTENT=#{specific}"
    self
  end
  
  def event( specific )
    @code += "CONTENT=EVENT:#{specific}"
    self
  end
  
  def run
    temp_code = @code
    @code = ''
    @browser.goto 'javascript:(function() {var m64 = "' + Base64.strict_encode64( temp_code ) + '", n = "#save_recaptcha_image.iim";if(!/Chrome|Firefox\/\d+\.\d+\.\d+\.\d+/test(navigator.userAgent)){alert("iMacros: The embedded macros work with iMacros for Chrome or iMacros for Firefox. Support for IE is planned");return;}if(!/^(?:chrome|https?|file)/.test(location)){alert("iMacros: To run a macro, you need to open a website first.");return;}var div = document.getElementById("imacros-bookmark-div");if (!div){alert("Can not run macro, no iMacros div found");return;}var ta = document.getElementById("imacros-macro-container");ta.value = decodeURIComponent(atob(m64));div.setAttribute("name", n);var evt = document.createEvent("Event");evt.initEvent("iMacrosRunMacro", true, true);div.dispatchEvent(evt);}) ();'
  rescue
  end
  
  def run_url
    temp_code = @code
    @code = ''
    @browser.goto 'http://run.imacros.net/?code=' + Base64.strict_encode64( temp_code )
  rescue
  end
  
end