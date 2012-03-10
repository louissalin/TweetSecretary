class TweetController < ApplicationController
    skip_before_filter :authenticate_user!, :only => :index

    respond_to :html, :v1_json

    def index
    end

    def create
        t = JSON.parse(params[:tweet])

        tweet_id = t['tweet_id']
        is_my_reply = t['is_my_reply']
        originator = t['originator']
        reply_to = t['reply_to']
        retweet_count = t['retweet_count']
        text = t['text']

        @tweet = Tweet.first(conditions: {tweet_id: tweet_id})
        if @tweet == nil
            @tweet = TweetHelper.create_tweet tweet_id, originator, text, retweet_count, is_my_reply
            @tweet.save
        end

        respond_to do |format|
            format.v1_json { render :v1_json => @tweet }
        end
    end

    def show
        @tweet = Tweet.first(conditions: {tweet_id: "#{params[:id]}"})

        respond_to do |format|
            format.v1_json { render :v1_json => @tweet }
        end
    end

end

ActionController::Renderers.add(:v1_json) do |obj, options|
    json = obj.to_v1_json
    self.content_type ||= Mime::Type.lookup('application/vnd.tweetsecretary-v1+json')
    self.response_body = json
end
