require_relative 'emails'

class YahooThrough1Reg < Yahoo
  def new_email( id )
    @current_email = Email.find id
    return 'Wrong email provider' if !check_domain?
    
    go_to_first_url
    
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
    
  def go_to_first_url
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