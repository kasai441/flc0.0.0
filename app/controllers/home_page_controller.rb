class HomePageController < ApplicationController
  def index
    if logged_in?
      render 'show'
    else
      render 'index'
    end
  end
end
