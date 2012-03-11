class TweetController < ApplicationController
    skip_before_filter :authenticate_user!, :only => :index

    respond_to :v1_json
    respond_to :html, :only => [:show, :index]

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
        else
            render :v1_json => @tweet
            error = get_error '405',
                              'cannot create tweet',
                              "tweet with id #{tweet_id} already exists"

            
            response.body = '{"error":' + error.to_json + ',' + '"content":' + response.body + '}'
            return
        end

        respond_to do |format|
            format.v1_json { render :v1_json => @tweet }
            format.any { render :v1_json => @tweet, :status => 415 }
        end
    end

    def show
        @tweet = Tweet.first(conditions: {tweet_id: "#{params[:id]}"})

        respond_to do |format|
            format.v1_json { render :v1_json => @tweet }
        end

        response.body = '{"content":' + response.body + '}'
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
    json = obj.to_v1_json
    self.content_type ||= Mime::Type.lookup('application/vnd.tweetsecretary-v1+json')
    self.response_body = json
end
