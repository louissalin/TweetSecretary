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
                :status => 'unknown'
            }

            @tweet = Tweet.create!(@attr)
        end

        it "liking a tweet should set its status to 'liked'" do
            @tweet.like
            @tweet.status.should == 'liked'
        end

        it "disliking a tweet should set its status to 'disliked'" do
            @tweet.dislike
            @tweet.status.should == 'disliked'
        end
    end
end
