require 'spec_helper'
require "#{File.dirname(__FILE__)}/response_queries.rb"

describe TrainingSetController do
    include ResponseQueries

    describe "when not logged in on the site" do
        describe "GET 'training_set'" do
            it "should be successful" do
                get 'index'
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

        describe "GET 'training_set'" do
            before (:each) do
                attrs = {
                    :tweet_id => '12345',
                    :text => 'not my tweet',
                    :urls => [],
                    :pruned_text => 'not my tweet',
                    :originator => 'someone',
                    :reply_to => nil,
                    :retweet_count => 0,
                    :is_my_reply => false,
                    :mentions => [],
                    :status => 'liked',
                    :trained_timestamp => nil,
                    :owner => 'random@stranger.com'
                }

                Tweet.create!(attrs)
                TweetHelper.create_tweet(@user, 't123', 'someone', 'text', 0)
            end

            it "should only return tweets for the currently logged in user" do
                get :index, :format => :v1_json

                response.should be_successful
                training_set.count.should == 1
            end

        end
    end
end
