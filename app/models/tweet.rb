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
      self.to_json(:only => [:text, :pruned_text, :originator, :reply_to, :retweet_count, :urls, :is_my_reply, :mentions])
  end
end
