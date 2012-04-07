require 'spec_helper'
require 'helpers/tweet_helper.rb'
require "#{File.dirname(__FILE__)}/response_queries.rb"

describe TweetsController do
    include ResponseQueries

    describe "when not logged in on the site" do
        describe "GET 'index'" do
            it "should be successful" do
                get 'index'
                response.should be_successful
            end
        end

        describe "POST 'create'" do 
            it "should redirect to sign in" do
                post 'create'
                response.code.should == '302'
                response.should redirect_to(new_user_session_path)
            end
        end
    end

    describe "when logged in on the site" do
        before (:each) do
            @user = Factory.create(:user)
            sign_in @user
        end

        describe "GET 'show' an existing tweet" do
            before (:all) do
                @id = '123'
                @text = "@lonestardev check out what @buddy did: bit.ly/1234. It's amazing!"
                @originator = "my_friend"
                @retweet_count = 0
            end

            before (:each) do
                @tweet = TweetHelper.create_tweet @user, @id, @originator, @text, 
                                                  @retweet_count
                @tweet.save

                get 'show', :id => '123', :format => :v1_json
            end

            it "should show the tweet" do
                response.should be_successful
                content.to_json.should == @tweet.to_v1.to_json
            end

            it "should not include the mongo ID in the json response" do
                content.key('"_id":"').should == nil
            end

            it "should have the proper media type" do
                response.content_type.should == 'application/vnd.tweetsecretary-v1+json'
            end

            it "should give the option to like the tweet" do
                actions.count.should == 2
                actions[0]['url'].should == "#{Rails.application.routes.url_helpers.tweet_path(@id)}/like"
            end

            it "should give the option to dislike the tweet" do
                actions[1]['url'].should == "#{Rails.application.routes.url_helpers.tweet_path(@id)}/dislike"
            end
        end
    end

    describe "when using the API" do
        before (:each) do
            @user = Factory.create(:user)
            sign_in @user
        end

        describe "POST 'create'" do
            before (:each) do
                @id = '123'
                @text = "@lonestardev check out what @buddy did: bit.ly/1234. It's amazing!"
                @originator = "my_friend"
                @retweet_count = 0
                @reply_to = 'lonestardev'

                @tweet = {
                    :tweet_id => @id,
                    :originator => @originator,
                    :reply_to => @reply_to,
                    :retweet_count => @retweet_count,
                    :text => @text
                }
            end

            it "should return a 415 unsupported media type if not proper format" do
                post :create, :tweet => @tweet.to_json, :format => :html
                response.should_not be_successful
                response.code.should == '415'
            end

            it "should be respond with json" do
                post :create, :tweet => @tweet.to_json, :format => :v1_json
                test_tweet_response
            end

            it "should save the tweet" do
                post :create, :tweet => @tweet.to_json, :format => :v1_json
                get 'show', :id => '123', :format => :v1_json
                test_tweet_response
            end

            it "shouldn't add if tweet id is already present" do
                post :create, :tweet => @tweet.to_json, :format => :v1_json
                post :create, :tweet => @tweet.to_json, :format => :v1_json

                Tweet.count.should == 1
                error['code'].should == "405"
                error['message'].should == 'cannot create tweet'
                error['description'].should == 'tweet with id 123 already exists'
            end

            it "should figure out if the tweet was a reply to me" do
                sign_out @user
                user = Factory.create(:user, 
                                      :name => 'lp',
                                      :email => 'lp@lp.com', 
                                      :twitter_handle => 'lonestardev')
                sign_in user
                
                post :create, :tweet => @tweet.to_json, :format => :v1_json
                tweet['is_my_reply'].should == true
            end

            it "should give the option to like the tweet" do
                post :create, :tweet => @tweet.to_json, :format => :v1_json
                actions.count.should == 2
                actions[0]['url'].should == "#{Rails.application.routes.url_helpers.tweet_path(@id)}/like"
            end

            it "should give the option to dislike the tweet" do
                post :create, :tweet => @tweet.to_json, :format => :v1_json
                actions[1]['url'].should == "#{Rails.application.routes.url_helpers.tweet_path(@id)}/dislike"
            end
        end

        describe "POST 'like'" do
            before (:each) do
                @id = '123'
                @text = "@lonestardev check out what @buddy did: bit.ly/1234. It's amazing!"
                @originator = "my_friend"
                @retweet_count = 0
                @reply_to = 'lonestardev'

                @tweet = {
                    :tweet_id => @id,
                    :originator => @originator,
                    :reply_to => @reply_to,
                    :retweet_count => @retweet_count,
                    :text => @text
                }

                post :create, :tweet => @tweet.to_json, :format => :v1_json
                post :like, :id => @tweet[:tweet_id], :format => :v1_json
            end

            it "should be respond with json" do
                test_tweet_response
            end

            it "should return a 415 unsupported media type if not proper format" do
                post :like, :id => @tweet[:tweet_id], :format => :html
                response.should_not be_successful
                response.code.should == '415'
            end

            it "should return a 404 if tweet not found" do
                post :like, :id => '555', :format => :v1_json

                error['code'].should == "404"
                error['message'].should == 'cannot find tweet'
                error['description'].should == 'tweet with id 555 cannot be found'
            end

            it "should set the tweet status to 'liked'" do
                tweet['status'].should == 'liked'
            end

            it "should save the tweet" do
                get 'show', :id => '123', :format => :v1_json
                tweet['status'].should == 'liked'
            end

            it "should give the option to dislike the tweet" do
                actions.count.should == 1
                actions[0]['rel'].should == 'dislike'
            end
        end

        describe "POST 'dislike'" do
            before (:each) do
                @id = '123'
                @text = "@lonestardev check out what @buddy did: bit.ly/1234. It's amazing!"
                @originator = "my_friend"
                @retweet_count = 0
                @reply_to = 'lonestardev'

                @tweet = {
                    :tweet_id => @id,
                    :originator => @originator,
                    :reply_to => @reply_to,
                    :retweet_count => @retweet_count,
                    :text => @text,
                    :trained_timestamp => nil
                }

                post :create, :tweet => @tweet.to_json, :format => :html
                post :dislike, :id => @tweet[:tweet_id], :format => :v1_json
            end

            it "should be respond with json" do
                test_tweet_response
            end

            it "should return a 415 unsupported media type if not proper format" do
                post :like, :id => @tweet[:tweet_id], :format => :html
                response.should_not be_successful
                response.code.should == '415'
            end

            it "should return a 404 if tweet not found" do
                post :dislike, :id => '555', :format => :v1_json

                error['code'].should == "404"
                error['message'].should == 'cannot find tweet'
                error['description'].should == 'tweet with id 555 cannot be found'
            end

            it "should set the tweet status to 'disliked'" do
                tweet['status'].should == 'disliked'
            end

            it "should save the tweet" do
                get 'show', :id => '123', :format => :v1_json
                tweet['status'].should == 'disliked'
            end

            it "should give the option to like the tweet" do
                actions.count.should == 1
                actions[0]['rel'].should == 'like'
            end

            it "should set the trained_timestamp value" do
                get 'show', :id => '123', :format => :v1_json
                tweet['trained_timestamp'].should include(Time.now.strftime('%Y-%m-%dT%H:%M:%S'))
            end
        end

        def test_tweet_response
            response.should be_successful
            tweet['tweet_id'].should == @id
            tweet['originator'].should == @originator
            tweet['reply_to'].should == @reply_to
            tweet['retweet_count'].should == @retweet_count
            tweet['text'].should == @text
        end
    end

    #describe "when testing complex tweets" do
        #before (:each) do
            #@user = Factory.create(:user)
            #sign_in @user
        #end

        #describe "POST 'create'" do
            #it "should work" do
                #tweet = "{\"tweet_id\":\"179450071027425280\",\"originator\":\"haacked\",\"reply_to\":\"robconery\",\"retweet_count\":0,\"text\":\"@robconery It's shit developers who write software say: http://t.co/Ac6HYjwP\n:) :)\"}"

                #pp tweet
                #post :create, :tweet => tweet, :format => :v1_json
                #response.should be_successful
            #end
        #end
    #end
end
