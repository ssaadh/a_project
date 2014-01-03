require_relative '../lib/app'
require_relative 'emails'

class Yahoo < Emails
  def provider
    @provider = 'yahoo'
  end
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

class YahooThrough1Reg < Yahoo
  def new_email( id )
    @current_email = Email.find id
    return 'Wrong email provider' if !check_domain?
    
    go_to
    
    step_2
    puts '2'
    step_3
    puts '3'
    step_4
    puts '4'
    step_5
    puts '5'
    step_6
    puts '6'
    step_7
    puts '7'
    step_8
    puts '8'
    step_9
    puts '9'
    
    finish_up_new_email
  end
    
  def go_to
    probability = rand( 1..4 )
    puts "goto #{probability}"
    case probability
      when 1..3 then
        # 1, 2
        @browser.goto one_of_urls( 'yahoo.com' )
      when 4 then
        # 3, 4
        @browser.goto one_of_urls( 'my.yahoo.com', www: false )
    end #case    
    sign_in_link
  end
  
    private
  
    def sign_in_link
      @browser.element( text: 'Sign In' ).click
    end
  
    def google_sign_in_page
      google_sign_in_link = @browser.link( id: 'ggLink' ).when_present.href
      @browser.goto google_sign_in_link
    end
  
  
  public
  
  # Step 2
  # Go to google oAuth sign-in page
  def step_2
    google_sign_in_page
  end
  
  # Step 3
  # Enter in details for alternate email aka the Gmail info and click to next page
  def step_3
    if half_and_half
      set_email = @current_email.alternate_email.full
    else
      set_email = @current_email.alternate_email.username
    end
    @browser.text_field( id: 'Email' ).set set_email
    @browser.text_field( id: 'Passwd' ).set @current_email.alternate_email.password
    @browser.form( id: /login/ ).button.click
  end
  
  # Step 4
  # Click the 'Accept' or submit button where Yahoo asks for the oAuth permissions as "Yahoo! would like to:..."
  def step_4
    #@browser.element( id: 'policy_message' ).click
    begin
      Watir::Wait.until { @browser.button( text: 'Accept' ).present? }
      sleep 1
      
      #<button id="submit_approve_access" type="submit" tabindex="1" class="goog-buttonset-action" onclick="return lso.approveButtonAction();">Accept</button>
      #@browser.button( id: /submit/ ).click
    
      #@browser.button( text: 'Accept' ).when_present.hover
      @browser.button( text: 'Accept' ).click
    rescue
    end
  end
  
  # Step 5
  #def please_verify_your_account
  def step_5
    # clicking link opens new window
    #link (html a element) id is specifically "gBtnLnk"
    sign_in_url = @browser.element( id: 'gBtn' ).link.href
    @browser.goto sign_in_url
  end
  
  def step_6
    @browser.text_field( id: 'Passwd' ).set @current_email.alternate_email.password
  end
  
  def step_7
    # username
    if !@current_email.username.blank?
      @browser.text_field( id: 'yahooid' ).set @current_email.username
    else
      @browser.text_field( id: 'yahooid' ).click
    
      # suggestion
      if rand( 1..2 ) == 1
        random_number = 0
      else
        random_number = rand( 1..2 )
      end
      @browser.element( id: 'yahoo-domain-suggs' ).li( index: random_number ).click
    end
    
    # check username (only needed when actually going to edit a taken username)
    #@browser.button( text: 'Check' )
    
    # password
    @browser.text_field( id: 'password' ).set @current_email.password
    
    # button
    @browser.element( id: 'agreementButton' ).button.click
  end
  
  def step_8
    @browser.text_field( id: 'passwd' ).set @current_email.password
    
    @browser.button( text: 'Sign In' ).click
  end
  
  def step_9
    @browser.link( text: 'Keep Theme' ).click
  end
end

##

# 'link 2'
class YahooThrough2Reg < Yahoo
  def new_email( id )
    self.current_email = Email.find id
    return 'Wrong email provider' if !check_domain?
    
    go_to
    
    @browser.goto google_sign_in_link
    puts 'step 2'
    
    if half_and_half
      google_email = @current_email.alternate_email.full
    else
      google_email = @current_email.alternate_email.username
    end    
    google_password = @current_email.alternate_email.password
    google_oauth_sign_in( google_email, google_password )
    puts 'step 3'
    
    accept_google_oauth_permissions
    puts 'step 4'
    
    return
    
    step_5
    puts 'step 5'
    sign_up_fields_first_half
    sign_up_fields_second_half    
    continue_button.click
    
    step_6
    puts 'step 6'
    
    step_7
    puts 'step 7'
    
    step_8
    puts 'step 8'
    
    step_9
    puts 'step 9'
    
    finish_up_new_email
  end
    
  def go_to
    probability = rand( 1..9 )
    puts "goto #{probability}"
    case probability
      when 1..5 then
        # 1, 2
        @browser.goto one_of_urls( 'yahoo.com' )
        mail_link
    
      when 8..9 then
        # 3, 4
        @browser.goto one_of_urls( 'my.yahoo.com', www: false )
        mail_link
    
      when 6..7 then
        # 5, 6
        if half_and_half
          @browser.goto one_of_urls( 'mail.yahoo.com', www: false )
        else
          @browser.goto one_of_urls( 'login.yahoo.com', www: false )
        end
    end #case    
  end
  
    private
  
    def mail_link
      @browser.link( href: /mail.yahoo.com/ ).click
    end
  
  public
  
  # Step 2
  def google_sign_in_link
    @google_sign_in_link = @browser.link( id: 'ggLink' ).when_present.href
  end
  
  # Step 3
  # Enter in details for alternate email aka the Gmail info and click to next page
  def google_oauth_sign_in( username = nil, password = nil )
    @browser.text_field( id: 'Email' ).set username
    @browser.text_field( id: 'Passwd' ).set password
    @browser.form( id: /login/ ).button.click
  end
  
  # Step 4
  # Click the 'Accept' or submit button where Yahoo asks for the oAuth permissions as "Yahoo! would like to:..."
  def accept_google_oauth_permissions
    if @browser.button( text: 'Accept' ).present?
      attempts = 0
      begin
        sleep 2
        #@browser.button( id: /submit/ ).click
        @browser.button( text: 'Accept' ).click
      rescue
        attempts += 1
        retry unless attempts > 5
      end
    end
  end
  
  # Step 5
  # Sign up page.
  
    # This is same for either link. Small chance for different html though.
    def sign_up_fields_first_half
      # first name
      # optional, sometimes
      if !@current_email.first_name.blank?
        first_name_field.set @current_email.first_name
      end
      
      # last name
      # optional, sometimes
      if !@current_email.last_name.blank?
        last_name_field.set @current_email.last_name
      end
    
      # birthday
        # month is drop down
        birthday_month_field.select @current_email.birthday_specifics.month.capitalize
        # day field
        birthday_day_field.set @current_email.birthday_specifics.day
        # year field
        birthday_year_field.set @current_email.birthday_specifics.year
    end
  
    # Same fields, but a healthy chance for different html
    def sign_up_fields_second_half
      # Username field
      username_field.set @current_email.username
      # check button but not needed
    
      # password
      password_field.set @current_email.password
      
      # password verification
      password_verification_field.set @current_email.password
      
    end
  
    # should be same for both links, at least for first sign up form/page
    def continue_button
      @browser.button( :value, 'Continue' )
    end
  
  # Not sure what happens after pressing continue button here
  def step_6
    
  end
  
  # At some point you get sent back to the home page? Maybe you also have to re-enter Yahoo password before or after?
  
  # Then you get to the inbox and the theme bit
  def step_X
    
  end
  
  # maybe
  def step_8X
    @browser.text_field( id: 'passwd' ).set @current_email.password
    
    @browser.button( text: 'Sign In' ).click
  end
  
  # maybe
  def step_9X
    @browser.link( text: 'Keep Theme' ).click
  end
  
  private
  
    def first_name_field
      @browser.text_field( :id, 'fn' )
    end
  
    def last_name_field
    @browser.text_field( :id, 'ln' )
    end
    
    def birthday_month_field
      @browser.select_list( :id, 'month' )
    end
    
    def birthday_day_field
      @browser.text_field( :id, 'day' )
    end
    
    def birthday_year_field
      @browser.text_field( :name, 'by' )
    end
    
    def username_field
      @browser.text_field( :id, 'yahooid' )
    end
    
    def password_field
      @browser.text_field( :id, 'password' )
    end
    
    def password_verification_field
      @browser.text_field( :id, 'passwordconfirm' )
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