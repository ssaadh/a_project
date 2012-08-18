require_relative 'hostedblogs'

class Ee2 < Forums
end

class Ee2Reg < Ee2
  def what_happened
    @browser.goto 'http://codeigniter.com/forums/member/register/'
    @browser.text.include? 'Username'

    ## registration form
    main_form = @browser.form( :id => 'register_member_form' )

    ## main information
    main_form.text_field( :name => 'username' ).set( @generate.username )
    main_form.text_field( :name => 'password' ).set( @generate.password )
    main_form.text_field( :name => 'password_confirm' ).set( @generate.password )
    main_form.text_field( :name => 'email' ).set( @email )
    
    ## proprietary captcha
    captcha_answer = solve_captcha_image( 'src', '*captcha*.jpg' )
    main_form.text_field( :name => 'captcha' ).set( captcha_answer )
    
    ## accept and submit
    main_form.check_box( :name => 'accept_terms' ).set
    main_form.button( :type => 'submit' ).click
  end
end