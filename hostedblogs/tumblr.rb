require_relative 'hostedblogs'

class Tumblr < Hostedblogs
end

class TumblrReg < Tumblr
  def what_happened
    @browser.goto 'https://www.tumblr.com/'
    @browser.text.include? 'About'

    ## registration form
    @browser.form( :id => 'register_form' ).wait_until_present
    main_form = @browser.form( :id => 'register_form' )
    
    main_form.text_field( :name => 'user_email' ).set( @email)
    main_form.text_field( :name => 'user_password' ).set( @generate.password )
    main_form.text_field( :name => 'tumblelog_name' ).set( @generate.username )
    
    main_form.button( :type => 'submit' ).click

    ## profile form
    profile_form = @browser.form( :id => 'profile form' )

    profile_form.text_field( :name => 'first_name' ).set( @generate.first_name )
    profile_form.text_field( :name => 'last_name' ).set( @generate.second_name )
    profile_form.text_field( :name => 'description' ).set( @generate.about_yourself )
    
    profile_form.button( :type => 'submit' ).click
  end
end