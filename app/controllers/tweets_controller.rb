class TweetsController < ApplicationController
    skip_before_filter :authenticate_user!, :only => :index

    respond_to :v1_json
    respond_to :html, :only => [:show, :index]

    def index
    end

    def create
        t = JSON.parse(params[:tweet])
        tweet_id = t['tweet_id']
        originator = t['originator']
        reply_to = t['reply_to']
        retweet_count = t['retweet_count']
        text = t['text']

        error = nil

        @tweet = Tweet.first(conditions: {tweet_id: tweet_id})
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

    def show
        @tweet = Tweet.first(conditions: {tweet_id: "#{params[:id]}"})

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
end

ActionController::Renderers.add(:v1_json) do |obj, options|
    self.content_type ||= Mime::Type.lookup('application/vnd.tweetsecretary-v1+json')

    body = '{'
    if options[:error] != nil
        error = options[:error]
        error = error.to_json unless error.respond_to?(:to_str)

        body += '"error":' + error + ','
    end

    body += '"content":' + obj.to_v1_json
    body += '}'

    self.response_body = body 
end
