require_relative 'emails'

class Hotmail < Email
  def provider
    @provider = 'hotmail'
  end
end

class HotmailReg < Hotmail
  def what_happened
    @browser.goto 'https://edit.yahoo.com/registration?.intl=us&.lang=en-US&new=1&.done=http%3A//mail.yahoo.com&.src=ym'
    @browser.text.include? 'Account'

    ## registration form
    @browser.form( :id => 'regFormBody' ).wait_until_present
    main_form = @browser.form( :id => 'regFormBody' )

    ## personal info
    main_form.text_field( :id => 'firstname' ).set( @generate.first_name )
    main_form.text_field( :id => 'secondname' ).set( @generate.last_name )
    main_form.text_field( :id => 'gender' ).set( @generate.gender.capitalize )
    main_form.select_list( :id => 'mm' ).set( @generate.month )
    main_form.select_list( :id => 'dd' ).set( @generate.day )
    main_form.select_list( :id => 'yyy' ).set( @generate.year )
    main_form.select_list( :id => 'postalcode' ).set( @generate.zipcode )
    
    ## id/password
    
    #choose whether domain is going to be @ymail.com or @rocketmail.com.
    if rand( 1...3 ) == 1
      domain = 'yahoo.com'
    else
      domain = 'ymail.com'
    end    
    main_form.select_list( :id => 'domain' ).set( domain )
    main_form.text_field( :id => 'yahooid' ).set( @generate.username )    
    
    main_form.text_field( :id => 'password' ).set( @generate.password )
    main_form.text_field( :id => 'passwordconfirm' ).set( @generate.password )

    ## recovery
    main_form.select_list( :id => 'secquestion' ).set( main_form.select_list( :id => 'secquestion' ).option[ rand( 1...8 ) ] )
    main_form.text_field( :id => 'secquestionanswer' ).set( @generate.phrase_one )

    main_form.select_list( :id => 'secquestion2' ).set( main_form.select_list( :id => 'secquestion2' ).option[ rand( 1...17 ) ] )
    main_form.text_field( :id => 'secquestionanswer2' ).set( @generate.phrase_two )

    ## captcha
    main_form.image( :id => 'captchaV5ClassicCaptchaImg' ).wait_until_present
    captcha_answer = solve_captcha_image( 'id', 'captcha*' )
    main_form.text_field( :name => 'captchaAnswer' ).set( captcha_answer )
    
    take_screenshot
    ## submit
    main_form.button( :type => 'submit' ).click
    
    finish_up_new_email
  end
  
  def new_email
    
  end
  
  def first_name_field
    @b.text_field( :id, 'iFirstName' )
  end
  
  def last_name_field
    @b.text_field( :id, 'iLastName' )
  end
  
  def username_field
    @b.text_field( :id, 'imembernamelive' )
  end
  
  def username_domain_field
    #dropdown
  end
  
  def password_field
    @b.text_field( :id, 'iPwd' )
  end
  
  def password_verification_field
    @b.text_field( :id, 'iRetypePwd' )
  end
  
  def zip_code_field
    @b.text_field( :id, 'iZipCode' )
  end
  
  def birth_month_field
    #dropdown
  end
  
  def birth_day_field
    #dropdown
  end
  
  def birth_year_field
    #dropdown
  end
  
  def gender_field
    #dropdown
  end
  
  def alternate_email_field
    @b.text_field( :id, 'iAltEmail' )
  end
  
  def captcha_image
    #image
  end
  
  def captcha_answer_field
    @b.text_field( :id, /wlspispSolutionElement/ )
  end
  
  def create_account_button
    @b.button( :value, 'Create account' )
  end
end