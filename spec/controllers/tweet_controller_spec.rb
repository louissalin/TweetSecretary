require 'spec_helper'
require 'helpers/tweet_helper.rb'

describe TweetController do
    describe "when not logged in" do
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

    describe "when logged in" do
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
                @is_my_reply = true
            end

            before (:each) do
                @tweet = TweetHelper.create_tweet @id, @originator, @text, 
                                                  @retweet_count, @is_my_reply
                @tweet.save

                get 'show', :id => '123', :format => :v1_json
            end

            it "should show the tweet" do
                response.should be_successful
                content.to_json.should == @tweet.to_v1_json
            end

            it "should not include the mongo ID in the json response" do
                content.key('"_id":"').should == nil
            end

            it "should have the proper media type" do
                response.content_type.should == 'application/vnd.tweetsecretary-v1+json'
            end
        end

        describe "POST 'create'" do
            before (:each) do
                @id = '123'
                @text = "@lonestardev check out what @buddy did: bit.ly/1234. It's amazing!"
                @originator = "my_friend"
                @retweet_count = 0
                @is_my_reply = true

                @tweet = {
                    :tweet_id => @id,
                    :is_my_reply => @is_my_reply,
                    :originator => @originator,
                    :reply_to => "lonestardev",
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
        end

        def test_tweet_response
            response.should be_successful
            body.to_json.index(@tweet[:tweet_id].to_json).should >= 0
            body.to_json.index(@tweet[:is_my_reply].to_json).should >= 0
            body.to_json.index(@tweet[:originator].to_json).should >= 0
            body.to_json.index(@tweet[:reply_to].to_json).should >= 0
            body.to_json.index(@tweet[:retweet_count].to_json).should >= 0
            body.to_json.index(@tweet[:text].to_json).should >= 0
        end
    end

    def body 
        body = JSON.parse(response.body)
    end

    def content
        body['content']
    end

    def error
        body['error']
    end
end
