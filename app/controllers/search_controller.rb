class SearchController < ApplicationController
  def index
    @hosts = Host.all
  end
end
