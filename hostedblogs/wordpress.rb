require_relative 'hostedblogs'

class Wordpress < Hostedblogs
end

class WordpressReg < Wordpress
  def what_happened
    @browser.goto 'https://en.wordpress.com/signup/'
    @browser.text.include? 'Username'

    ## registration form
    main_form = @browser.form( :id => 'setupform' )

    main_form.text_field( :name => 'blogname' ).set( @generate.username )
    main_form.text_field( :name => 'user_name' ).set( @generate.username )
    main_form.text_field( :name => 'pass1' ).set( @generate.password )
    main_form.text_field( :name => 'pass2' ).set( @generate.password )
    main_form.text_field( :name => 'user_email' ).set( @email)

    main_form.button( :type => 'submit' ).click

    ## profile form
    profile_form = @browser.form( :id => 'profile form' )

    profile_form.text_field( :name => 'first_name' ).set( @generate.first_name )
    profile_form.text_field( :name => 'last_name' ).set( @generate.second_name )
    profile_form.text_field( :name => 'description' ).set( @generate.about_yourself )
    
    profile_form.button( :type => 'submit' ).click
  end
end