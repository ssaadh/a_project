require_relative '../lib/app'

class Emails < App
  attr_reader :provider
  
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
end