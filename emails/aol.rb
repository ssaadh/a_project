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
    puts "goto #{probability}"
    case probability
      when 1..3 then
        ## 1.
        # aol.com -> "sign up" link    
        @browser.goto one_of_urls( 'aol.com' )
        @browser.link( text: 'Sign Up' ).click
        #@browser.link( text: 'Sign Up', href: /new.aol.com/ ).click
    
      when 4 then
        ## 2.
        # direct url
        @browser.goto one_of_urls( 'new.aol.com', www: false )
    
      when 5 then
        ## 3.
        # in-direct urls
        urls = Array.new
        # webmail.aol.com (goes to my.screenname.aol.com), myaccount.aol.com (goes to my.screenname.aol.com), my.screenname.aol.com
        urls << 'webmail.aol.com'
        #urls << 'myaccount.aol.com'
        #urls << 'my.screenname.aol.com'
        @browser.goto urls.sample
        #@browser.link( text: 'Get a Free Username' ).click
        @browser.link( id: 'getSn' ).click
    end #case
    
    ## 2.
    # aol.com -> "read mail" link -> "Sign up for a FREE account" button
    #@browser.goto one_of_urls( 'aol.com' )
    
    ## 3.
    # http://get.aol.com/mybenefits/?ncid=txtlnkusaolp00000112 ?
  end
  
  def new_email( id )
    self.current_email = id
    return 'Wrong email provider' if !check_domain?
    
    go_to
    #@browser.text.include? 'Account'
    
    ## registration form
    @browser.form.wait_until_present
    
    ## first section of first/last name, username, and password/verification
    create_email_section
    
    about_you_section
    
    recovery_section
    
    #captcha solving
    verify_section
    
    submit_button.click
    
    finish_up_new_email
    
    # press ok button confirmation page
    
    # get sent to the forbidden page
    
    # move over to aol.com and then mail
    # or move over to mail.aol.com
    
    # optional stuff like click okay to the intro popups and stuff
    # optional stuff of going to inbox, clicking on intro message
  end
  
  def create_email_section
    first_name_field.set @current_email.first_name
    last_name_field.set @current_email.last_name
    
    # different than normal
    username_complex @current_email.username
    
    password_field.set @current_email.password
    password_verification_field.set @current_email.password
  end
  
  def about_you_section
    birthday_month_selection( @current_email.birthday_specifics.month.capitalize )
    birthday_day_field.set @current_email.birthday_specifics.day
    birthday_year_field.set @current_email.birthday_specifics.year
    
    gender_selection( @current_email.gender.capitalize )
    
    zip_code_field.set @current_email.zip_code
  end
  
  def recovery_section
    security_question_selection( @current_email.secret_question_1 )
    security_answer_field.set @current_email.secret_answer_1
    
    alternate_email_field.set @current_email.alternate_email.full
  end
  
  def verify_section
    ## captcha
    if captcha_image.present?
      #captcha_solving
      captcha_response_field
    end
  end
  
  ##
  
  def username_complex( username )
    if !username.blank?
      username_field.set username
    else
      # username suggestions
      # for broader, just try /username/ or similar
    
      @browser.text_field( id: 'desiredSN' ).click
    
      # 3/4 chance to choose one of the first 3/5 usernames.
      if (1..3) === rand( 1..4 )
        random_number = rand( 0..2 )
      else
        random_number = rand( 3..4 )
      end      
    
      @browser.element( id: 'username-suggestions' ).li( index: random_number ).link.when_present.click
      # Get the chosen username and save to database
      @current_email.username = username_field.text
      @current_email.save
    end
  end
  
  #private
  
    def first_name_field
      @browser.text_field( id: 'firstName' )
    end
  
    def last_name_field
      @browser.text_field( id: 'lastName' )
    end
  
    def username_field
      @browser.text_field( id: 'desiredSN' )
    end
  
    def password_field
      @browser.text_field( id: 'password' )
    end
  
    def password_verification_field
      @browser.text_field( id: 'verifyPassword' )
    end
    
    def birthday_month_selection( month )
      birth_month_element = @browser.element( id: 'dobMonthSelectBoxIt' )
      birth_month_element.click
      @browser.element( id: 'dobMonthSelectBoxItOptions' ).li( text: month ).when_present.click
    end
    
    def birthday_day_field
      @browser.text_field( id: 'dobDay' )
    end
    
    def birthday_year_field
      @browser.text_field( id: 'dobYear' )
    end
  
    def gender_selection( gender )
      gender_element = @browser.element( id: 'genderSelectBoxIt' )
      gender_element.click
      @browser.element( id: 'genderSelectBoxItOptions' ).li( text: gender ).when_present.click
    end
    
    def zip_code_field
      @browser.text_field( id: 'zipCode' )
    end
    
    def security_question_selection( question )
      security_question_element = @browser.element( id: 'acctSecurityQuestionSelectBoxItContainer' )
      security_question_element.click
      @browser.element( id: 'acctSecurityQuestionSelectBoxItOptions' ).link( text: question ).when_present.click
    end
    
    def security_answer_field
      @browser.text_field( id: 'acctSecurityAnswer' )
    end
    
    def alternate_email_field
      @browser.text_field( :id, 'altEMail' )
    end
    
    def captcha_image
      @browser.image( id: 'regImageCaptcha' )
    end
    
    def captcha_solving
      @captcha_answer = solve_captcha_image( 'src', 'regImageCaptcha' )
    end
    
    def captcha_response_field
      @browser.text_field( name: 'wordVerify' ).click
      Watir::Wait.until( 60 ) { text_file_touched? }
      remove_touched_file
    end
    
    def submit_button
      @browser.button( type: 'submit', value: 'Sign Up' )
    end
  
  def confirm_alternate_email
    @browser.text_field( id: 'password' ).set #@generate.password
    @browser.button( type: 'submit', value: 'OK' ).click
  end
end