require_relative 'hostedblogs'

class Phpbb3 < Forums
end

class Phpbb3Reg < Phpbb3
  def what_happened
    @browser.goto 'http://www.phpbb.com/community/ucp.php?mode=register'
    
    ######
    # TOS Page
    ######
    if @browser.text.include? 'I agree to these terms'
      @browser.button( :id => 'agreed' ).click
    end

    ######
    # Registration Page
    ######
    if @browser.text.include? 'account is activated'
      main_form = @browser.form( :id => 'register' )

      ## main information
      main_form.text_field( :name => 'username' ).set( @generate.username )
      main_form.text_field( :name => 'email' ).set( @email )
      main_form.text_field( :name => 'email_confirm' ).set( @email )
      main_form.text_field( :name => 'new_password' ).set( @generate.password )
      main_form.text_field( :name => 'password_confirm' ).set( @generate.password )
    
      ## timezone drop down list
      random_number = rand( 1...3 )    
    
      if random_number == 1
        timezone = '[UTC - 5] Eastern Standard Time'
      elsif random_number == 2
        timezone = '[UTC - 6] Central Standard Time'
      else
        timezone = '[UTC - 8] Pacific Standard Time'
      end
    
      main_form.select_list( :name => 'tz' ).set( timezone )
    
      ## optional, sometimes visible: gender    
      if main_form.text.include? 'Gender:'
        if rand( 1...2 ) == 1
          main_form.select_list( :id => 'pf_gender' ).set( @generate.gender.capitalize )
        end
      end
    
      ## sometimes visible: phrase captcha
      if main_form.text.include? 'This question is a means of preventing automated form submissions by spambots.'
        htmled = Nokogiri::HTML.parse( main_form.html )
        phrase = htmled.css( h3 ).next.css( 'label' ).text
        answer = ''#do a sql loop for phrase scraped versus phrases in sql.
        main_form.text_field( :id => 'answer' ).set( answer )
      end
      
      ## sometimes visible: phpbb captcha
      if main_form.image( 'alt' => 'Confirmation code' )
      end

      ## submit
      main_form.button( :type => 'submit' ).click
    end
  end
end