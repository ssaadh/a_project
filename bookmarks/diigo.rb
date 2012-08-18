require_relative 'bookmarks'

class Diigo < Bookmarks
end

class DiigoReg < Diigo
  def what_happened
    @browser.goto 'https://secure.diigo.com/sign-up'
    @browser.text.include? 'Choose a Username'

    ## registration form
    @browser.form( :id => 'registerForm' ).wait_until_present
    main_form = @browser.form( :id => 'registerForm' )

    main_form.text_field( :name => 'username' ).set( @generate.username )
    main_form.text_field( :name => 'first_name' ).set( @generate.first_name )
    main_form.text_field( :name => 'last_name' ).set( @generate.last_name )
    main_form.text_field( :name => 'email' ).set( @email)
    main_form.text_field( :name => 'password' ).set( @generate.password )
    main_form.text_field( :name => 'rPassword' ).set( @generate.password )
    
    recaptcha_captcha()
    
    main_form.button( :type => 'submit' ).click
  end
end