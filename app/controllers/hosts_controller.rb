class HostsController < ApplicationController
  def index
    @hosts = Host.all
  end
end
