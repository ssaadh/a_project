require_relative '../lib/app'

class Yahoo < Email
end

class YahooThrough < Yahoo
  def new_row
    @new_email = Email.new
    @new_email.domain = 'gmail'
        
    @generate = Generate.new #this is already done in that App superclass initialize method but i haven't been through this old code and structure in so long so just doing it again here for current simplicity.
    
    # Default, common
    @new_email.gender = @generate.gender
    
    @new_email.first_name = @generate.first_name
    @new_email.last_name = @generate.last_name
    
    @new_email.password = @generate.password
    
    @new_email.date_of_birth = @generate.date_of_birth
    
    @new_email.save
  end
end

class YahooThroughReg < Yahoo
  # Step 5
  def please_verify_your_account
    # clicking link opens new window
    #link (html a element) id is specifically "gBtnLnk"
    sign_in_url = @browser.element( id: 'gBtn' ).link.href
    @browser.goto sign_in_url
  end
  
  def step_6
    @browser.text_field( id: 'Passwd' ).set #current_email.alternate_email.password #
  end
  
  def step_7
    # username
    @browser.text_field( id: 'yahooid' ).set 
    
    # suggestion
    if rand( 1..2 ) == 1
      random_number = 0
    else
      random_number = rand( 1..2 )
    end
    @browser.element( id: 'yahoo-domain-suggs' ).li( index: random_number ).click
    
    # check username (only needed when actually going to edit a taken username)
    @browser.button( text: 'Check' )
    
    # password
    @browser.text_field( id: 'password' ).set current_email.password
    
    # button
    @browser.element( id: 'agreementButton' ).button.click
  end
  
  def step_8
    @browser.text_field( id: 'passwd' ).set current_email.password
    
    @browser.button( text: 'Sign In' ).click
  end
  
  def step_9
    @browser.link( text: 'Keep Theme' ).click
  end
end


class YahooReg < Yahoo
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
    
    ## submit
    main_form.button( :type => 'submit' ).click
  end
end