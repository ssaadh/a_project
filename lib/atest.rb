require_relative 'agems'

@client = DeathByCaptcha.http_client( 'atsco', 'Hello1011' )
@browser = Watir::Browser.new :ff, :profile => 'default'

