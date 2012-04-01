require 'spec_helper'

describe Tweet do
    describe "create new tweet" do
        before(:each) do
            @attr = { 
                :text => 'this is a tweet: http://btl.ly/bla',
                :pruned_text => 'this is a tweet',
                :originator => '@lonestardev',
                :reply_to => '',
                :retweet_count => 0,
                :urls => nil,
                :is_my_reply => false,
                :mentions => nil
            }
        end

        it "should create a new instance given a valid attribute" do
            Tweet.create!(@attr)
        end
    end

    describe "update status" do
        before(:each) do
            @attr = { 
                :text => 'this is a tweet: http://btl.ly/bla',
                :pruned_text => 'this is a tweet',
                :originator => '@lonestardev',
                :reply_to => '',
                :retweet_count => 0,
                :urls => nil,
                :is_my_reply => false,
                :mentions => nil,
                :status => 'unknown',
                :trained_timestamp => nil
            }

            @tweet = Tweet.create!(@attr)
        end

        it "liking a tweet should set its status to 'liked' and update the timestamp" do
            @tweet.like
            @tweet.status.should == 'liked'
            @tweet.trained_timestamp.to_s.should include(Time.now.strftime('%Y-%m-%dT%H:%M:%S'))
        end

        it "disliking a tweet should set its status to 'disliked' and update the timestamp" do
            @tweet.dislike
            @tweet.status.should == 'disliked'
            @tweet.trained_timestamp.to_s.should include(Time.now.strftime('%Y-%m-%dT%H:%M:%S'))
        end
    end
end
