#if you don't use @last right now, then that means the generate class can/will get funky if used more than once as an instance. fine for now.
class Generate
  attr_reader :gender, :first_name, :last_name, :age
  attr_reader :birth_yyyy, :birth_yy, :birth_year, :month, :mont_abbr, :month_number, :month_filled, :day, :day_filled
  attr_reader :zip_code, :username, :password, :about
  attr_reader :phrase_one, :phrase_two
  
  def initialize
    if rand( 1...3 ) == 3
      @gender = 'female'
      @gender_single = 'f'
    else
      @gender = 'male'
      @gender_single = 'm'
    end
    
    @age = rand( 18...50 )
    @birth_yyyy = Time.now.strftime( "%Y" ).to_i - @age
    @birth_yy = @birth_yyyy.to_s[ 2..-1 ]
    @birth_year = @birth_yyyy #alias/default
    
    if @gender == 'male'
      @first_name = 'Mark'
    else
      @first_name = 'Susan'
    end
    
    @last_name = 'Daniels'
    
    @month = 'March'
    @month_abbr = 'Mar'
    @month_number = '3'
    @month_filled = '03'
    
    @day = rand( 31 ) + 1
    @day_filled = 11 #lol too lazy to check if single digit right now
    
    @zipcode = '08855'
    
    @username = 'overandaboutt' + rand( 99 ).to_s
    
    @password = 'Heyhey101!'
    
    @about = 'Hello everyone. I\'m just your regular old person...not too good with computers, but trying to get out there and try out new things like blogging. Hope to see your around!'    
    
    @phrase_one = 'that would be correct sir'
    @phrase_two = 'no i dont know'
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