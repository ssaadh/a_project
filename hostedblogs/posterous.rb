require_relative 'hostedblogs'

class Posterous < Hostedblogs
end

class PosterousReg < Posterous
  def what_happened
    @browser.goto 'https://posterous.com/register'

    ## registration form
    @browser.form( :id => 'register' ).wait_until_present
    main_form = @browser.form( :id => 'register' )

    main_form.text_field( :id => 'user_mail' ).set( @email)
    main_form.text_field( :id => 'user_password' ).set( @generate.password )
    main_form.text_field( :id => 'siteaddr_register' ).set( @generate.username )
    
    main_form.button( :type => 'submit' ).click
  end
end