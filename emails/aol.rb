require_relative '../lib/app'
require_relative 'emails'

class Aol < Emails
  def provider
    @provider = 'aol'
  end
end

class AolGeneration < Aol
  def new_row
    @new_email = Email.new
    @new_email.domain = 'aol'
        
    @generate = Generate.new #this is already done in that App superclass initialize method but i haven't been through this old code and structure in so long so just doing it again here for current simplicity.
    
    # Default, common
    @new_email.gender = @generate.gender
    
    @new_email.first_name = @generate.first_name
    @new_email.last_name = @generate.last_name
    
    @new_email.password = @generate.password
    
    @new_email.date_of_birth = @generate.date_of_birth
    
    # More specific
    @new_email.zip_code = @generate.zip_code
    
    # Completely specific
    security_questions_list = [ 
      'What was the name of your first school?', 
      'What was the first concert you saw?', 
      'In which city did your parents meet?', 
      'What was your favorite childhood book?', 
      'What was your childhood nickname?', 
      'What was the name of your first pet?' 
    ]
    
    security_question = security_questions_list.sample
    
    @new_email.secret_question_1 = security_question
    
    @new_email.save
  end
end

class AolReg < Aol
  def go_to
    probability = rand( 1..5 )
    case probability
      when 1..2 then
        ## 1.
        # aol.com -> "sign up" link    
        @browser.goto one_of_urls( 'aol.com' )
        @browser.link( text: 'Sign Up' ).click
        #@browser.link( text: 'Sign Up', href: /new.aol.com/ ).click
    
      when 3 then
        ## 2.
        # direct url
        @browser.goto one_of_urls( 'new.aol.com' )
    
      when 4..5 then
        ## 3.
        # in-direct urls
        urls = Array.new
        # webmail.aol.com (goes to my.screenname.aol.com), myaccount.aol.com (goes to my.screenname.aol.com), my.screenname.aol.com
        urls << 'webmail.aol.com'
        urls << 'myaccount.aol.com'
        urls << 'my.screenname.aol.com'
        @browser.goto urls.sample
        @browser.link( text: 'Get a Free Username' ).click
        #@browser.link( id: 'getSn' ).click
    end #case
    
    ## 2.
    # aol.com -> "read mail" link -> "Sign up for a FREE account" button
    #@browser.goto one_of_urls( 'aol.com' )
    
    ## 3.
    # http://get.aol.com/mybenefits/?ncid=txtlnkusaolp00000112 ?
  end
  
  def new_email( id )
    @current_email = Email.find id
    return 'Wrong email provider' if !check_domain
    
    go_to
    #@browser.text.include? 'Account'
    
    ## registration form
    @browser.form.wait_until_present
    
    ## create email [div]
    @browser.text_field( id: 'firstName' ).set @current_email.first_name
    @browser.text_field( id: 'lastName' ).set @current_email.last_name
    
    if !@current_email.username.blank?
      @browser.text_field( id: 'desiredSN' ).set @current_email.username
    else
      # username suggestions
      # for broader, just try /username/ or similar
    
      if (1..3) === rand( 1..4 )
        random_number = rand( 0..2 )
      else
        random_number = rand( 3..4 )
      end
    
      @browser.element( id: 'username-suggestions' ).li( index: random_number ).click
    end
    
    @browser.text_field( id: 'password' ).set @current_email.password
    @browser.text_field( id: 'verifyPassword' ).set @current_email.password
    
    
    ## about you [div]
    
    date_of_birth_specifics = DateOfBirthSpecifics( @current_email.date_of_birth )
    @browser.select_list( id: 'dobMonth' ).set date_of_birth_specifics.month.capitalize
    @browser.text_field( id: 'dobDay' ).set date_of_birth_specifics.day
    @browser.text_field( id: 'dobYear' ).set date_of_birth_specifics.birth_yyyy
    
    @browser.select_list( id: 'gender' ).set @current_email.gender.capitalize
    
    @browser.text_field( id: 'zipCode' ).set @current_email.zip_code
    
    ## recovery
    # Honeypot
    #recovery_question_list = @browser.select_list( id: 'acctSecurityQuestion' )
    #recovery_question_list.set recovery_question_list.option[ rand( 1...6 ) ]
    
    security_questions_list = [ 
      'What was the name of your first school?', 
      'What was the first concert you saw?', 
      'In which city did your parents meet?', 
      'What was your favorite childhood book?', 
      'What was your childhood nickname?', 
      'What was the name of your first pet?' 
    ]
    
    security_question = security_questions_list.sample
    
    #def security_question_box
    @browser.element( id: 'acctSecurityQuestionSelectBoxItContainer' ).click
    
    # def security_question_options
    @browser.element( id: 'acctSecurityQuestionSelectBoxItOptions' ).link( @current_email.secret_question_1 ).click
    
    
    @browser.text_field( id: 'acctSecurityAnswer' ).set @current_email.secret_answer_1 # @TODO Random from text file
    
    #@browser.text_field( id: 'mobileNum' ).set @generate.mobile_number # @TODO uhh
    
    @browser.text_field( id: 'altEMail' ).set @current_email.alternate_email # @TODO uhh
    
    
    ## verify [div]
    
    ## captcha
    @browser.image( id: 'regImageCaptcha' ).wait_until_present
    #captcha_answer = solve_captcha_image( 'id', 'regImageCaptcha' )
    #@browser.text_field( :name => 'wordVerify' ).set( captcha_answer )
    @browser.text_field( name: 'wordVerify' ).hover
    Watir::Wait.until { text_file_touched }
    remove_touched_file
    
    ## submit
    @browser.button( type: 'submit', value: 'Sign Up' ).click
    
    finish_up_new_email
  end
  
  def confirm_alternate_email
    @browser.text_field( id: 'password' ).set #@generate.password
    @browser.button( type: 'submit', value: 'OK' ).click
  end
end