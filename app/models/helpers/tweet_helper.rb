class TweetHelper
    def create_tweet(id, originator, text, retweet_count = 0, is_my_reply = false)
        attrs = {
            :tweet_id => id,
            :text => text,
            :urls => extract_urls(text),
            :pruned_text => prune_text(text),
            :originator => originator,
            :reply_to => extract_reply_to(text),
            :retweet_count => retweet_count,
            :is_my_reply => is_my_reply,
            :mentions => extract_mentions(text),
        }

        Tweet.create!(attrs)
    end

private
    URL_REGEX = /\s(http(s)?:\/\/)?([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3})(\/)?([\S]*[^\.|\s])?/
    def prune_text(text)
        text.gsub(/@([^\s])+\s/, '')
            .gsub(URL_REGEX, '')
            .gsub(/[.|,|!|@|:|?|>|<|\||\[|\]|\{|\}|"|;|#|%|^|&|*|\(|\)|-|_|=|+]/, ' ')
            .gsub(/\s+/, ' ')
            .strip
    end

    def extract_urls(text)
        url_parts = text.scan URL_REGEX
        url_parts.map {|p| p.join('')}
    end

    def extract_reply_to(text)
        /^@\S+/.match(text)[0][1..-1]
    end

    def extract_mentions(text)
        text.scan(/@\S+/).map {|m| m[1..-1].strip}
    end
end
