require 'spec_helper'

describe TweetController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.code.should == '302'
      response.should redirect_to(new_user_session_path)
    end
  end

end
