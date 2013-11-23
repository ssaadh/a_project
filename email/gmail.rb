require_relative '../lib/app'

class Gmail < Email
end

class GmailReg < Gmail
  def what_happened
    #@browser.goto 'https://edit.yahoo.com/registration?.intl=us&.lang=en-US&new=1&.done=http%3A//mail.yahoo.com&.src=ym'
    #@browser.text.include? 'Account'

    ## registration form
    @browser.form.wait_until_present

    ## create email [div]
    @browser.text_field( id: 'FirstName' ).set @generate.first_name
    @browser.text_field( id: 'LastName' ).set @generate.last_name
    
    @browser.text_field( id: 'GmailAddress' ).set @generate.username
    
    @browser.text_field( id: 'Passwd' ).set @generate.password
    @browser.text_field( id: 'PasswdAgain' ).set @generate.password
    
    
    ## about you [div]
    
    birth_month_element = @browser.element( id: 'BirthMonth' )
    birth_month_element.click
    birth_month_element.div( text: @generate.month.capitalize ).click
    @browser.text_field( id: 'BirthDay' ).set @generate.day
    @browser.text_field( id: 'BirthYear' ).set @generate.birth_yyyy
    
    gender_element = @browser.element( id: 'Gender' )
    gender_element.click
    gender_element.div( text: @generate.gender.capitalize ).click
    
    @browser.text_field( id: 'RecoveryPhoneNumber' ).set @generate.mobile_number # @TODO uhh
    
    @browser.text_field( id: 'RecoveryEmailAddress' ).set @generate.alternate_email # @TODO uhh

    ## recovery
    recovery_question_list = @browser.select_list( id: 'acctSecurityQuestion' )
    recovery_question_list.set recovery_question_list.option[ rand( 1...6 ) ]
    @browser.text_field( id: 'acctSecurityAnswer' ).set @generate.phrase_one # @TODO Random from text file
    
    
    ## verify [div]
    
    ## captcha
    @browser.image( src: /google\.com\/recaptcha/ ).wait_until_present
    #captcha_answer = solve_captcha_image( 'src', 'regImageCaptcha' )
    #@browser.text_field( :name => 'recaptcha_response_field' ).set( captcha_answer )
    @browser.text_field( name: 'recaptcha_response_field' ).hover
    Watir::Wait.until { text_file_touched }
    remove_touched_file
    
    @browser.checkbox( id: 'TermsOfService' ).set
    
    ## submit
    @browser.button( type: 'submit' ).click
  end
  
  def confirm_alternate_email
    #@browser.text_field( id: 'password' ).set #@generate.password
    #@browser.button( type: 'submit', value: 'OK' ).click
  end
end