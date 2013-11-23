require_relative '../lib/app'

class Aol < Email
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
    recovery_question_list = @browser.select_list( id: 'acctSecurityQuestion' )
    recovery_question_list.set recovery_question_list.option[ rand( 1...6 ) ]
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