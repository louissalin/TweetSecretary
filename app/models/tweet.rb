class Tweet
  include Mongoid::Document
  fields :text, :type => String
  fields :pruned_text, :type => String
  fields :originator, :type => String
  fields :reply_to, :type => String
  fields :retweet_count, :type => Integer
  fields :urls, :type => Hash
  fields :is_my_reply, :type => Boolean
  fields :mentions, :type => Hash
end
