class SearchController < ApplicationController
  def index
    @checkin = params.fetch(:checkin, nil)
    @checkout = params.fetch(:checkout, nil)
    @guest = params.fetch(:guest, nil).to_i

    @hosts = if @checkin.nil? || @checkout.nil?
               []
             else
               checkin = @checkin.to_date
               checkout = @checkout.to_date
               Host.reservable(checkin, checkout, @guest)
             end
  end


end
