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

##

# 'link 2'
class YahooThrough2Reg < Yahoo
  def new_email( id )
    self.current_email = Email.find id
    return 'Wrong email provider' if !check_domain?
    
    # step 1
    go_to
    
    # step 2
    @browser.goto google_sign_in_link
    puts 'step 2'
    
    # step 3
    if half_and_half
      google_email = @current_email.alternate_email.full
    else
      google_email = @current_email.alternate_email.username
    end    
    google_password = @current_email.alternate_email.password
    google_oauth_sign_in( google_email, google_password )
    puts 'step 3'
    
    # step 4
    accept_google_oauth_permissions
    puts 'step 4'
        
    # step 5
    sign_up_fields_first_half
    sign_up_fields_second_half
    continue_button.click
    puts 'step 5'
    
    # step 6
    theme_selection
    puts 'step 6'
    
    #step_7
    #puts 'step 7'
    
    #step_8
    #puts 'step 8'
    
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
      
      # @TODO Use alternate email's birthday if date_of_birth column is blank
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
    
      # password
      password_field.set @current_email.password
      
      # password verification
      password_verification_field.set @current_email.password
      
      # make sure the check went through
      #<a id="change">Change</a>
    end
  
    # should be same for both links, at least for first sign up form/page
    def continue_button
      @browser.button( :value, 'Continue' )
    end
  
  # step 6
  def theme_selection
    if half_and_half    
      # keep theme
      @browser.link( text: 'Keep Theme' ).click
    else
      # choose one of the visible 8
      random_number = rand( 0..7 )
      @browser.element( :id, 'onboard-dialog' ).element( :class => 'inner', :index => random_number ).click
    end
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