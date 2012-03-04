class TweetController < ApplicationController
  def index
    @users = User.all
  end
end
