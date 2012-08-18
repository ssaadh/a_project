require_relative 'hostedblogs'

class Vb4 < Forums
end

class Vb4Reg < Vb4
  def what_happened
    @browser.goto 'http://www.xanga.com/register.aspx?ref=gs'
    @browser.text.include? 'Username'

    ## registration form
    @browser.form( :id => 'frmRegister' ).wait_until_present
    main_form = @browser.form( :id => 'frmRegister' )

    main_form.text_field( :id => 'registrationModule_txtregusrnm' ).set( @generate.username )
    main_form.text_field( :id => 'registrationModule_txtPassword1' ).set( @generate.password )
    main_form.text_field( :id => 'registrationModule_txtPassword2' ).set( @generate.password )
    main_form.text_field( :id => 'registrationModule_txtEmail' ).set( email )

    ## captcha
    main_form.image( :id => 'registrationModule_imgLetters' ).wait_until_present
    captcha_answer = solve_captcha_image( 'src', '*xanga.com/randletters*' )
    main_form.text_field( :id => 'registrationModule_txtLetters' ).set( captcha_answer )

    # birthday
    main_form.select_list( :id => 'registrationModule_DOB_month' ).set( @generate.month_abbr )
    main_form.select_list( :id => 'registrationModule_DOB_day' ).set( @generate.day_filled )
    main_form.select_list( :id => 'registrationModule_DOB_year' ).set( @generate.year )
    
    # agree and submit
    main_form.check_box( :id => 'registrationModule_chkReadTerms' ).set
    main_form.button( :type => 'submit' ).click

  end
end