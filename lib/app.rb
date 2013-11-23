require_relative 'agems'
require_relative 'aconfig'
require_relative 'amethods'

require_relative 'a_other'

class App
  attr_accessor :browser, :client, :generate
  
  def initialize
    @client = DeathByCaptcha.http_client( 'atsco', 'Hello1011' )
    @browser = Watir::Browser.new :ff, :profile => 'default'
    @generate = Generate.new
    @email = email
    @imacros = Imacros.new( @browser )
  end
  
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