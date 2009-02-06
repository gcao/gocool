# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_letbego_session',
  :secret      => '3ab0ef9713356fa8d08424c770584d95ad14f2ae54d43c9b8e4881b5491fe024407ec2f45548384946410d5a412c0c1dea5ab21da811fb43e2c538fa817d1cdc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
