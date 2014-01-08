require_relative '../lib/app'
require_relative 'emails'

class Gmail < Emails
  def provider
    @provider = 'gmail'
  end
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
  def go_to_first_url 
    probability = rand( 1..7 )
    puts "goto #{probability}"
    case probability
      when 1..2 then
        # 2
        @browser.goto one_of_urls( 'google.com' )
        @browser.link( text: 'Gmail' ).click
        create_an_account_button
    
      when 3..4 then
        # 3
        @browser.goto one_of_urls( 'google.com' )
        @browser.link( text: 'Sign in' ).click
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
  
  def new_email( id )
    self.current_email = id
    return 'Wrong email provider' if !check_domain?
    
    go_to_first_url
    
    # registration form
    @browser.form.wait_until_present
    
    ## first section of first/last name, username, and password/verification
    create_email_section
    
    # if username inputted is already taken then an error message will present itself when moving away from said field
    # 
    if !username_available?
      Watir::Wait.until( 60 ) { text_file_touched? }
      remove_touched_file
      
      #<div class="username-suggestions" id="username-suggestions" style="display: block;">Available: <a href="">jennifercook604</a><a href="">cookjennifer01</a><a href="">cookj091</a></div>
      @current_email.username = username_field.text
      @current_email.save
    end
    
    about_you_section
    
    recovery_section
    
    if !location_is_united_states?
      adjust_mobile_phone_country
      #mobile_phone_number_field.set '' # remove any numbers that may be preset like different country code
      adjust_location
    end
    
    #captcha solving
    verify_section
    
    terms_of_service_checkbox.set    
    submit
  end
  
  def create_email_section
    first_name_field.set @current_email.first_name
    last_name_field.set @current_email.last_name
    
    username_field.set @current_email.username
    
    password_field.set @current_email.password
    password_verification_field.set @current_email.password
  end
  
  def about_you_section
    birthday_month_selection( @current_email.birthday_specifics.month.capitalize )
    birthday_day_field.set @current_email.birthday_specifics.day
    birthday_year_field.set @current_email.birthday_specifics.year
    
    gender_selection( @current_email.gender.capitalize )
  end
  
  def recovery_section
    alternate_email_field.set @current_email.alternate_email.full
  end
  
  def verify_section
    ## captcha
    captcha_image
    #captcha_solving
    captcha_response_field
  end
  
  ##
  
  def adjust_mobile_phone_country
    mobile_phone_country_dropdown.click
    if half_and_half
      mobile_phone_country_dropdown_option( 'United States' ).click
    else
      mobile_phone_country_dropdown_option( 'United States' ).parent.click
    end
  end
  
    # mobile phone section
    def mobile_phone_country_dropdown
      @browser.table( class: 'i18n_phone_number_input' ).th.div
    end
  
    # United States
    def mobile_phone_country_dropdown_option( country_name )
      # possible to also select .parent (up to two times)
      # is there a sibling option?
      @browser.div( class: 'goog-menu goog-menu-vertical i18n-phone-select-country-menu' ).when_present.span( text: country_name )
    end
    
    def mobile_phone_number_field
      @browser.text_field( id: 'RecoveryPhoneNumber' )
    end
  
  ##
  
  def location_is_united_states?
    if location_dropdown.text == 'United States'
      return true
    else
      return false
    end
  end
  
  def adjust_location
    location_dropdown.click
    location_dropdown_option( 'United States' ).click
  end
  
    def location_dropdown
      @browser.element( id: 'CountryCode' ).element( class: /caption/ )
    end
    
    def location_dropdown_option( country_name )
      @browser.element( id: 'CountryCode' ).element( class: /goog-menu goog-menu-vertical/ ).when_present.div( text: country_name )
    end
  
  ##
  
  def username_not_available_notice_html
    #<span role="alert" id="errormsg_0_GmailAddress">Someone already has that username. Try another?</span>
    #id="errormsg_0_GmailAddress"
    @browser.span( class: 'errormsg', text: 'Someone already has that username. Try another?')
  end
  
  def username_available?
    if username_not_available_notice_html.present? == true
      return false
    else    
      return true
    end
  end
  
  #private
  
    def first_name_field
      @browser.text_field( id: 'FirstName' )
    end
  
    def last_name_field
      @browser.text_field( id: 'LastName' )
    end
  
    def username_field
      @browser.text_field( id: 'GmailAddress' )
    end
  
    def password_field
      @browser.text_field( id: 'Passwd' )
    end
  
    def password_verification_field
      @browser.text_field( id: 'PasswdAgain' )
    end
    
    def birthday_month_selection( month )
      birth_month_element = @browser.element( id: 'BirthMonth' )
      birth_month_element.click
      birth_month_element.div( text: month ).click
    end
    
    def birthday_day_field
      @browser.text_field( id: 'BirthDay' )
    end
    
    def birthday_year_field
      @browser.text_field( id: 'BirthYear' )
    end
  
    def gender_selection( gender )
      gender_element = @browser.element( id: 'Gender' )
      gender_element.click
      gender_element.div( text: gender ).click
    end
    
    def alternate_email_field
      @browser.text_field( :id, 'RecoveryEmailAddress' )
    end
    
    def captcha_image
      @browser.image( src: /google\.com\/recaptcha/ )
    end
    
    def captcha_solving
      @captcha_answer = solve_captcha_image( 'src', 'regImageCaptcha' )
    end
    
    def captcha_response_field
      @browser.text_field( name: 'recaptcha_response_field' ).click
      Watir::Wait.until( 60 ) { text_file_touched? }
      remove_touched_file
    end
    
    def terms_of_service_checkbox
      @browser.checkbox( id: 'TermsOfService' )
    end
    
    def submit
      #@browser.button( id: 'submitbutton' ).click
      @browser.send_keys :enter        
    end
  
  def confirm_alternate_email
    #@browser.text_field( id: 'password' ).set #@generate.password
    #@browser.button( type: 'submit', value: 'OK' ).click
  end
end