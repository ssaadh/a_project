require_relative '../lib/app'

class Emails < App
  attr_reader :provider
  
  def finish_up_new_email
    #If conditions show that the page post submission is shown
    @current_email.creation_date = Time.now
    @current_email.created = true
  end

  def check_domain
    if @current_email.domain != @provider
      return false
    end
  end
end