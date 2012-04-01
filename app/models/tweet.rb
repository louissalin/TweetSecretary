class Tweet
  include Mongoid::Document
  include Rails.application.routes.url_helpers

  field :tweet_id, :type => String
  field :text, :type => String
  field :pruned_text, :type => String
  field :originator, :type => String
  field :reply_to, :type => String
  field :retweet_count, :type => Integer
  field :urls, :type => Hash
  field :is_my_reply, :type => Boolean
  field :mentions, :type => Hash
  field :status, :type => String
  field :trained_timestamp, :type => DateTime

  def like
      self.status = 'liked'
      self.trained_timestamp = Time.now
  end

  def dislike
      self.status = 'disliked'
      self.trained_timestamp = Time.now
  end

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
            mentions: self.mentions,
            status: self.status,
            actions: get_actions,
            trained_timestamp: self.trained_timestamp.to_s
          }
      }
  end

private
  def get_actions
      actions = []
      if status == 'unknown' || status == 'disliked'
          actions << { url: "#{tweet_path(self.tweet_id)}/like", rel: 'like' }
      end

      if status == 'unknown' || status == 'liked'
          actions << { url: "#{tweet_path(self.tweet_id)}/dislike", rel: 'dislike' }
      end

      actions
  end
end
