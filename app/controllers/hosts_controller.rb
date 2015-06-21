class HostsController < ApplicationController

  def index
    @hosts = Host.all
  end

  def show
    @checkin = params.fetch(:checkin, nil)
    @checkout = params.fetch(:checkout, nil)
    @guest = params.fetch(:guest, nil).to_i

    @host = Host.find(params[:id])

    @rooms = Room.where(host: @host)
    @rooms = if @checkin.present? && @checkout.present?
                  checkin = @checkin.to_date
                  checkout = @checkout.to_date
                  @rooms.reservable(checkin, checkout, @guest)
                end
  end

end
