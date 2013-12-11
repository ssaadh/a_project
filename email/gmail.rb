require_relative '../lib/app'

class Gmail < Email
end

class GmailGeneration < Gmail
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


class GmailReg < Gmail
  def go_to    
    probability = rand( 1..7 )
    case probability
      when 1..2 then
        # 2
        @browser.goto one_of_urls( 'google.com' )
        @browser.link( text: 'Gmail' ).click
        create_an_account_button
    
      when 3..4 then
        # 3
        @browser.goto one_of_urls( 'google.com' )
        @browser.link( text: 'Sign In' ).click
        create_an_account_link
    
      when 5..6 then
        # 1
        @browser.goto one_of_urls( 'gmail.com' )
        create_an_account_button
    
      when 7 then
        # 4, 5
        if half_and_half
          @browser.goto one_of_urls( 'mail.google.com', www: false )
          create_an_account_button
        else
          @browser.goto one_of_urls( 'accounts.google.com', www: false )
          create_an_account_link
        end
    end #case
  end
  
    private
    
    def create_an_account_link
      @browser.link( text: 'Create an account' ).click
      #@browser.link( text: '/Create an account/' ).click
    end
    
    def create_an_account_button
      @browser.link( text: 'Create an account' ).click
    end
  
  
  public
  
  def new_email
    go_to

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
    
    #If conditions show that the page post submission is shown
    @current_email.creation_date = Time.now
    @current_email.created = true
  end
  
  def confirm_alternate_email
    #@browser.text_field( id: 'password' ).set #@generate.password
    #@browser.button( type: 'submit', value: 'OK' ).click
  end
end