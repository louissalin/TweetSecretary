require 'spec_helper'
require 'helpers/tweet_helper.rb'

describe TweetHelper do
    describe "creating a tweet" do
        before (:all) do
            @id = '123'
            @text = "@lonestardev check out what @buddy did: bit.ly/1234. It's amazing!"
            @originator = "my_friend"
            @retweet_count = 0
        end

        before (:each) do
            user = Factory.create(:user, 
                                  :name => 'lp',
                                  :email => 'lp@lp.com', 
                                  :twitter_handle => 'lonestardev')

            @tweet = TweetHelper.create_tweet user, @id, @originator, @text, @retweet_count
        end

        it "should extract attributes from a regular tweet" do
            @tweet.tweet_id.should == @id
            @tweet.text.should == @text
            @tweet.pruned_text.should == "check out what did It's amazing"
            @tweet.originator.should == @originator
            @tweet.reply_to.should == "lonestardev"
            @tweet.retweet_count.should == @retweet_count
            @tweet.is_my_reply.should == true
            @tweet.urls[0].should == "bit.ly/1234"
            @tweet.mentions[0].should == "lonestardev"
            @tweet.mentions[1].should == "buddy"
        end

        it "should set the status of the tweet to 'unknown'" do
            @tweet.status.should == 'unknown'
        end
    end

    describe "creating a tweet with missing mentions" do
        before (:all) do
            @id = '123'
            @text = "check out what did: bit.ly/1234. It's amazing!"
            @originator = "my_friend"
            @retweet_count = 0
        end

        before (:each) do
            user = Factory.create(:user, 
                                  :name => 'lp',
                                  :email => 'lp@lp.com', 
                                  :twitter_handle => 'lonestardev')

            @tweet = TweetHelper.create_tweet user, @id, @originator, @text, @retweet_count
        end

        it "should extract attributes from a regular tweet" do
            @tweet.tweet_id.should == @id
            @tweet.text.should == @text
            @tweet.pruned_text.should == "check out what did It's amazing"
            @tweet.originator.should == @originator
            @tweet.reply_to.should be_blank
            @tweet.retweet_count.should == @retweet_count
            @tweet.is_my_reply.should == true
            @tweet.urls[0].should == "bit.ly/1234"
            @tweet.mentions.count.should == 0
        end
    end

    describe "creating a tweet with missing URLs" do
        before (:all) do
            @id = '123'
            @text = "I feel good!"
            @originator = "my_friend"
            @retweet_count = 0
        end

        before (:each) do
            user = Factory.create(:user, 
                                  :name => 'lp',
                                  :email => 'lp@lp.com', 
                                  :twitter_handle => 'lonestardev')

            @tweet = TweetHelper.create_tweet user, @id, @originator, @text, @retweet_count
        end

        it "should extract attributes from a regular tweet" do
            @tweet.tweet_id.should == @id
            @tweet.text.should == @text
            @tweet.pruned_text.should == "I feel good"
            @tweet.originator.should == @originator
            @tweet.reply_to.should be_blank
            @tweet.retweet_count.should == @retweet_count
            @tweet.is_my_reply.should == true
            @tweet.urls.count.should == 0
            @tweet.mentions.count.should == 0
        end
    end
end
