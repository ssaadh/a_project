require_relative 'bookmarks'

class Delicious < Bookmarks
end

class DeliciousReg < Delicious
  def what_happened
    @browser.goto 'https://delicious.com/register'
    @browser.text.include? 'Username'

    ## registration form
    main_form = @browser.form( :id => 'register-form' )

    main_form.text_field( :name => 'username' ).set( @generate.username )
    main_form.text_field( :name => 'password-register' ).set( @generate.password )
    main_form.text_field( :name => 'email' ).set( @email)
    
    sleep 1 #just to let the checking javascript complete, just in fucking case

    main_form.a( :id => 'joinButton' ).click

    recaptcha_captcha()
    
    main_form.a( :text => 'No Robots Here' ).click
  end
end