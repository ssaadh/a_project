require_relative '../lib/app'

class Emails < App
  attr_reader :provider, :current_email, :new_email
  
  def initialize
    super
    provider
  end
  
  def finish_up_new_email
    #If conditions show that the page post submission is shown
    @current_email.creation_date = Time.now
    @current_email.created = true
    
    @current_email.save
  end

  def check_domain?
    if @current_email.domain == @provider
      return true
    else
      return false
    end
  end
  
  def lol
    @provider
  end
  
  def alternate_email_field( how, what )
    if !@current_email.alternate_email_id.blank?
      @browser.text_field( how, what ).set @current_email.alternate_email.full
    else
      @browser.text_field( how, what ).set @current_email.alternate_email_string
    end
  end
end