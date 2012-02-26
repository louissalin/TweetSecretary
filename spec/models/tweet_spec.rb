require 'spec_helper'

describe Tweet do
  before(:each) do
    @attr = { 
      :text => 'this is a tweet',
      :in_reply_to => '',
      :retweeted => false,
      :retweet_count => 0
    }
  end
  
  it "should create a new instance given a valid attribute" do
    Tweet.create!(@attr)
  end
end
