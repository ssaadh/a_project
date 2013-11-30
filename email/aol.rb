require_relative '../lib/app'

class Aol < Email
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
    @new_email.zip_code = @generate.zipcode
    
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
  def what_happened( id )
    @current_email = Email.find id
    if @current_email.domain != 'aol'
      return 'Wrong email provider'
    end
    
    #@browser.goto 'https://edit.yahoo.com/registration?.intl=us&.lang=en-US&new=1&.done=http%3A//mail.yahoo.com&.src=ym'
    #@browser.text.include? 'Account'
    
    ## registration form
    @browser.form.wait_until_present
    
    ## create email [div]
    @browser.text_field( id: 'firstName' ).set @current_email.first_name
    @browser.text_field( id: 'lastName' ).set @current_email.last_name
    
    @browser.text_field( id: 'desiredSN' ).set @current_email.username
    
    @browser.text_field( id: 'password' ).set @current_email.password
    @browser.text_field( id: 'verifyPassword' ).set @current_email.password
    
    
    ## about you [div]
    
    date_of_birth_specifics = date_of_birth_specifics( @current_email.date_of_birth )
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
    
    #If conditions show that the page post submission is shown
    @current_email.creation_date = Time.now
    @current_email.created = true
  end
  
  def confirm_alternate_email
    @browser.text_field( id: 'password' ).set #@generate.password
    @browser.button( type: 'submit', value: 'OK' ).click
  end
end