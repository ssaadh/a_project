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
  end
end

class AolReg < Aol
  def what_happened
    #@browser.goto 'https://edit.yahoo.com/registration?.intl=us&.lang=en-US&new=1&.done=http%3A//mail.yahoo.com&.src=ym'
    #@browser.text.include? 'Account'

    ## registration form
    @browser.form.wait_until_present
    
    ## create email [div]
    @browser.text_field( id: 'firstName' ).set @generate.first_name
    @browser.text_field( id: 'lastName' ).set @generate.last_name
    
    @browser.text_field( id: 'desiredSN' ).set @generate.username
    
    @browser.text_field( id: 'password' ).set @generate.password
    @browser.text_field( id: 'verifyPassword' ).set @generate.password
    
    
    ## about you [div]
    
    @browser.select_list( id: 'dobMonth' ).set @generate.month.capitalize 
    @browser.text_field( id: 'dobDay' ).set @generate.day
    @browser.text_field( id: 'dobYear' ).set @generate.birth_yyyy
    
    @browser.select_list( id: 'gender' ).set @generate.gender.capitalize
    
    @browser.text_field( id: 'zipCode' ).set @generate.zipcode
    
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
    @browser.element( id: 'acctSecurityQuestionSelectBoxItOptions' ).link( security_question ).click
    
    
    @browser.text_field( id: 'acctSecurityAnswer' ).set @generate.phrase_one # @TODO Random from text file
    
    @browser.text_field( id: 'mobileNum' ).set @generate.mobile_number # @TODO uhh
    
    @browser.text_field( id: 'altEMail' ).set @generate.alternate_email # @TODO uhh
    
    
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
  end
  
  def confirm_alternate_email
    @browser.text_field( id: 'password' ).set #@generate.password
    @browser.button( type: 'submit', value: 'OK' ).click
  end
end