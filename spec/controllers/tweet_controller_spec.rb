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
                @tweet = TweetHelper.new.create_tweet @id, @originator, @text, 
                                                      @retweet_count, @is_my_reply
                @tweet.save

                get 'show', :id => '123', :format => :v1_json
            end

            it "should show the tweet" do
                response.should be_successful
                response.body.should == 'json'
            end

            it "should have the proper media type" do
                response.content_type.should == 'application/vnd.tweetsecretary-v1+json'
            end
        end

        describe "POST 'create'" do
            it "should be successful" do
                response.should be_successful
            end

            it "should save the tweet" 
            it "shouldn't add if tweet id is alread present"
        end
    end
end
