class Tweet
  include Mongoid::Document

  field :text, :type => String
  field :pruned_text, :type => String
  field :originator, :type => String
  field :reply_to, :type => String
  field :retweet_count, :type => Integer
  field :urls, :type => Hash
  field :is_my_reply, :type => Boolean
  field :mentions, :type => Hash

  def to_v1_json
      'json'
  end
end
