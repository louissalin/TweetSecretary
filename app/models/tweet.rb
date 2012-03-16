class Tweet
  include Mongoid::Document

  field :tweet_id, :type => String
  field :text, :type => String
  field :pruned_text, :type => String
  field :originator, :type => String
  field :reply_to, :type => String
  field :retweet_count, :type => Integer
  field :urls, :type => Hash
  field :is_my_reply, :type => Boolean
  field :mentions, :type => Hash

  def to_v1
      {tweet: 
          {
            tweet_id: self.tweet_id,
            text: self.text,
            pruned_text: self.pruned_text,
            originator: self.originator,
            reply_to: self.reply_to,
            retweet_count: self.retweet_count,
            urls: self.urls,
            is_my_reply: self.is_my_reply,
            mentions: self.mentions
          }
      }
  end
end
