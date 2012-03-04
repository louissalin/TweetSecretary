require 'spec_helper'
require 'helpers/tweet_helper.rb'

describe TweetHelper do
    describe "creating a tweet" do
        before (:all) do
            @text = "@lonestardev check out what @buddy did: bit.ly/1234. It's amazing!"
            @originator = "my_friend"
            @retweet_count = 0
            @is_my_reply = true

            @helper = TweetHelper.new
        end

        before (:each) do
            @tweet = @helper.create_tweet @originator, @text, @retweet_count, @is_my_reply
        end

        it "should extract attributes from a regular tweet" do
            @tweet.text.should == @text
            @tweet.pruned_text.should == "check out what did It's amazing"
            @tweet.originator.should == @originator
            @tweet.reply_to.should == "lonestardev"
            @tweet.retweet_count.should == @retweet_count
            @tweet.is_my_reply.should == @is_my_reply
            @tweet.urls[0].should == "bit.ly/1234"
            @tweet.mentions[0].should == "lonestardev"
            @tweet.mentions[1].should == "buddy"
        end
    end
end
