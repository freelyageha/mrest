class HomeController < ApplicationController
  def index
    @recommend_hosts = Host.limit 6
  end
end
