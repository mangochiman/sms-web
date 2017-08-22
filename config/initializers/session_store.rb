# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sms-web_session',
  :secret      => '779aaca9319c58b47c3286ed491cd4fec162322e688c490f5ce13d658c4f7bd89b4cafe8792edee0cada36100f69e65c7eb81339205691fc7732f7e12295ea7c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
