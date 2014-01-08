# agems file requires a bunch of different stuff, but chances are if Watir hasn't been required yet then the rest haven't either.
# But when having these files being used under a Rails app like I've been quickly doing, then the requiring of these gems isn't needed as Rails will do it first.
if !defined? Watir
  require_relative 'agems'
end
require_relative 'aconfig'
require_relative 'amethods'

require_relative 'a_other'

class App
  attr_accessor :browser, :captcha_client, :generate
  
  def initialize( to_browser = true, to_generate = true, to_client = false )
    self.browser = true if to_browser == true
    self.generate = true if to_generate == true
    
    #self.captcha_client if to_client == true
    #@email = email
    #self.imacros if to_imacros == true
  end
  
    # setters
    def browser=( k )
      @browser ||= Watir::Browser.new :chrome#, :profile => 'default'
    end
  
    def generate=( k )
      @generate ||= Generate.new
    end
  
    def captcha_client=( username = 'atsco', password = 'Hello1011' )
      @captcha_client ||= DeathByCaptcha.http_client( username, password )
    end
  
    def imacros=( k )
      @imacros ||= Imacros.new( @browser )
    end
    
  def go_to( url )
    begin
      @browser.goto url
    rescue Net::ReadTimeout, Timeout::Error => error
      puts "hey this goto messed up: Exception #{error.class} : #{error}. And the message: #{error.message}"
    end
  end
  
  def take_screenshot( location = nil, name = nil )
    if location.nil?
      location = "#{ File.dirname( __FILE__ ) }/../debugging/screenshots/#{@provider}"
    end
    
    if name.nil?
      name = "id-#{@current_email.id}-#{Time.now.strftime( "%Y-%m-%d_%H-%M" )}" 
    end
    @browser.screenshot.save "#{location}/#{name}.png"
  end
  
  ##
  
  def recaptcha_captcha( automation = '' )
    if automation == ''
      automation = @browser
    end
    
    folder = '/Users/skinnymuch/Fuck/iMacros/Downloads/captcha_image/'
    file = 'recaptcha.jpg'
    path = folder + file
    
    automation.text_field( :name => 'recaptcha_response_field' ).wait_until_present
    @imacros.ondownload( folder, file ).img( 'href', '*google.com/recaptcha/api/image*' ).event( 'save_element_screenshot' ).run
    lame = 0
    until File.exist? path
      sleep 0.5
      lame += 1
      break if lame == 6
    end
    response = @client.decode( path )
    File.delete( folder + file )
    automation.text_field( :name => 'recaptcha_response_field' ).set( response[ 'text' ] )
    return response[ 'text' ]
  end
  
  def solve_captcha_image( attribute, value )
    if automation == ''
      automation = @browser
    end
    
    folder = '/Users/skinnymuch/Fuck/iMacros/Downloads/captcha_image/'
    file = rand( 10...1000000 ).to_s + rand( 10...1000000 ).to_s + '.jpg'
    path = folder + file
    
    @imacros.ondownload( folder, file ).img( attribute, value ).event( 'save_element_screenshot' ).run
    lame = 0
    until File.exist? path
      sleep 0.5
      lame += 1
      break if lame == 6
    end
    response = @client.decode( path )
    File.delete( path )
    return response[ 'text' ]
  end
  
end