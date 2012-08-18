require_relative 'bookmarks'

class Digg < Bookmarks
end

class DiggReg < Digg
  def what_happened
    @browser.goto 'http://digg.com'
    @browser.text.include? 'News'
    
    begin
      @browser.a( :text, 'No Thanks' ).click
    rescue
    end
    @browser.a( :text, 'Join Digg!' ).click
    @browser.a( :text, 'email address' ).when_present.click

    ## registration form
    @browser.form( :id => 'register' ).wait_until_present
    main_form = @browser.form( :id => 'register' )

    main_form.text_field( :name => 'email' ).set( @email)
    main_form.text_field( :name => 'register-username' ).set( @generate.username )
    main_form.text_field( :name => 'password-register' ).set( @generate.password )

    main_form.button( :text => 'Continue' ).click
    
    recaptcha_captcha()
    
    main_form.button( :text => 'Create Account' ).click
  end
end