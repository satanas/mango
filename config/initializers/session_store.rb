# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_porcinas_session',
  :secret      => '8332aa371bffbc90053504bcc151bac022ca801d42ea23ef70cb8017a26bbe69ec3af095282b05f56ec61d2b22dadfb428d82c5f34b9cb3276ca7c28673558de'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
