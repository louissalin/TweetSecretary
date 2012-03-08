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
                response.body.should == @tweet.to_v1_json
            end

            it "should not include the mongo ID in the json response" do
                response.body.index('"_id":"').should == nil
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
            end

            it "should be respond with json" do
                tweet = {:tweet_id => "123",
                         :is_my_reply => true,
                         :originator => "my_friend",
                         :reply_to => "lonestardev",
                         :retweet_count => 0,
                         :text => "@lonestardev check out what @buddy did: bit.ly/1234. It\'s amazing!"
                             }

                post :create, :tweet => tweet.to_json, :format => :v1_json

                response.should be_successful
                response.body.index(tweet[:tweet_id].to_json).should >= 0
                response.body.index(tweet[:is_my_reply].to_json).should >= 0
                response.body.index(tweet[:originator].to_json).should >= 0
                response.body.index(tweet[:reply_to].to_json).should >= 0
                response.body.index(tweet[:retweet_count].to_json).should >= 0
                response.body.index(tweet[:text].to_json).should >= 0
            end

            it "should save the tweet" 
            it "shouldn't add if tweet id is already present"
        end
    end
end
