class TweetHelper
    def self.create_tweet(current_user, id, originator, text, retweet_count = 0)
        attrs = {
            :tweet_id => id,
            :text => text,
            :urls => extract_urls(text),
            :pruned_text => prune_text(text),
            :originator => originator,
            :reply_to => extract_reply_to(text),
            :retweet_count => retweet_count,
            :is_my_reply => is_my_reply(current_user, text),
            :mentions => extract_mentions(text),
            :status => 'unknown'
        }

        Tweet.create!(attrs)
    end

private
    URL_REGEX = /\s(http(s)?:\/\/)?([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3})(\/)?([\S]*[^\.|\s])?/
    def self.prune_text(text)
        text.gsub(/@([^\s])+\s/, '')
            .gsub(URL_REGEX, '')
            .gsub(/[.|,|!|@|:|?|>|<|\||\[|\]|\{|\}|"|;|#|%|^|&|*|\(|\)|-|_|=|+]/, ' ')
            .gsub(/\s+/, ' ')
            .strip
    end

    def self.extract_urls(text)
        url_parts = text.scan URL_REGEX
        url_parts.map {|p| p.join('')}
    end

    def self.extract_reply_to(text)
        matches = /^@\S+/.match(text)

        if matches != nil
            matches[0][1..-1]
        else
            nil
        end
    end

    def self.extract_mentions(text)
        text.scan(/@\S+/).map {|m| m[1..-1].strip}
    end

    def self.is_my_reply(current_user, text)
        reply_to = extract_reply_to(text)
        reply_to.blank? || reply_to == current_user.twitter_handle
    end
end
