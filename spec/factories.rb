require 'factory_girl'

Factory.define :user do |u|
  u.name 'Test User'
  u.email 'user@test.com'
  u.password 'please'
  u.authentication_token 'token123'
  u.twitter_handle 'somehandle'
end

