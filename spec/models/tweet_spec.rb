require 'spec_helper'

describe Tweet do
  before(:each) do
    @attr = { 
      :text => 'this is a tweet: http://btl.ly/bla',
      :pruned_text => 'this is a tweet',
      :originator => '@lonestardev',
      :reply_to = '',
      :retweet_count => 0,
      :urls => nil,
      :is_my_reply = false,
      :mentions = nil
    }
  end
  
  it "should create a new instance given a valid attribute" do
    Tweet.create!(@attr)
  end
end
