require_relative 'bookmarks'

class Reddit < Bookmarks
end

class RedditReg < Reddit
  def what_happened
    @browser.goto 'https://ssl.reddit.com/login'

    ## registration form
    @browser.form( :id => 'login_reg' ).wait_until_present
    main_form = @browser.form( :id => 'login_reg' )

    main_form.text_field( :name => 'user' ).set( @generate.username )
    main_form.text_field( :name => 'email' ).set( @email )
    main_form.text_field( :name => 'passwd' ).set( @generate.password )
    main_form.text_field( :name => 'passwd2' ).set( @generate.password )

    ## captcha
    main_form.image( :class => 'capimage' ).wait_until_present
    captcha_answer = solve_captcha_image( 'src', '*captcha*.png' )
    main_form.text_field( :name => 'captcha' ).set( captcha_answer )
    
    main_form.button( :type => 'submit' ).click
  end
end