require_relative 'hostedblogs'

class Livejournal < Hostedblogs
end

class LivejournalReg < Livejournal
  def what_happened
    @browser.goto 'www.livejournal.com/create.bml'
    @browser.text.include? 'Username'

    ## registration form
    main_form = @browser.form( :method => 'post' )

    main_form.text_field( :id => 'create_user' ).set( @generate.username )
    main_form.text_field( :id => 'create_email' ).set( @email )
    main_form.text_field( :id => 'create_password1' ).set( @generate.password )
    main_form.text_field( :id => 'create_password2' ).set( @generate.password )
    main_form.select_list( :id => 'create_gender' ).set( @generate.gender.capitalize )
    
    # birthday form
    main_form.select_list( :id => 'create_bday_mm' ).set( @generate.month )
    main_form.text_field( :id => 'create_bday_dd' ).set( @generate.day )
    main_form.text_field( :id => 'create_bday_yyyy' ).set( @generate.year )
    
    recaptcha_captcha
    
    main_form.check_box( :id => 'create_news' ).clear
    main_form.button( :type => 'submit' ).click
  end
end