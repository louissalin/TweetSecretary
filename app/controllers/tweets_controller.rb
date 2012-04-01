class TweetsController < ApplicationController
    skip_before_filter :authenticate_user!, :only => :index

    respond_to :v1_json
    respond_to :html, :only => [:index]

    def index
        # show login page if user not logged in
        # else show html page with initial payload of tweets in json format
        # the page will have javascript to load tweets are they come in (eventually...)

        @tweets = Tweet.limit(20)
        @trained_tweets = Tweet.order_by([[:trained_timestamp, :desc]]).limit(10).each {|t| puts t.inspect}
    end

    def create
        t = JSON.parse(params[:tweet])
        tweet_id = t['tweet_id']
        originator = t['originator']
        reply_to = t['reply_to']
        retweet_count = t['retweet_count']
        text = t['text']

        error = nil

        @tweet = find_tweet(tweet_id)
        if @tweet == nil
            @tweet = TweetHelper.create_tweet current_user, tweet_id, originator, text, retweet_count
            @tweet.save
        else
            error = get_error '405',
                              'cannot create tweet',
                              "tweet with id #{tweet_id} already exists"
        end

        respond_to do |format|
            format.v1_json { render v1_json: @tweet, error: error }
            format.any { render v1_json: @tweet, status: 415 }
        end
    end

    def like
        tweet_id = params[:id]
        update_tweet_params(tweet_id) {|tweet| tweet.like}
    end

    def dislike
        tweet_id = params[:id]
        update_tweet_params(tweet_id) {|tweet| tweet.dislike}
    end

    def show
        @tweet = find_tweet(params[:id])

        respond_to do |format|
            format.v1_json { render v1_json: @tweet }
        end
   end

private
    def get_error(code, message, description)
        {
            :code => code,
            :message => message,
            :description => description
        }
    end

    def update_tweet_params(tweet_id)
        @tweet = find_tweet(tweet_id)

        if @tweet == nil
            error = get_error '404',
                              'cannot find tweet',
                              "tweet with id #{tweet_id} cannot be found"
        else
            yield @tweet
            @tweet.save
        end

        respond_to do |format|
            format.v1_json { render v1_json: @tweet, error: error }
            format.any { render v1_json: @tweet, status: 415 }
        end
    end

    def find_tweet(tweet_id)
        Tweet.first(conditions: {tweet_id: tweet_id})
    end
end

ActionController::Renderers.add(:v1_json) do |obj, options|
    self.content_type ||= Mime::Type.lookup('application/vnd.tweetsecretary-v1+json')

    body = '{'
    if options[:error] != nil
        error = options[:error]
        error = error.to_json unless error.respond_to?(:to_str)

        body += '"error":' + error + ','
    end

    content = '"nil"'
    if obj != nil
        content = obj.to_v1.to_json
    end

    body += '"content":' + content
    body += '}'

    self.response_body = body 
end
