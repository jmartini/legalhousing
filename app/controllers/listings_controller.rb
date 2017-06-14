require 'pry'

class ListingsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @listings = Listing.all

    if params[:start_date] and params[:end_date]
      @start_date = DateTime(params[:start_date], "%y-%m-%d")
      @end_date = DateTime(params[:end_date], "%y-%m-%d")

      @listings = @listings.date_range(@start_date, @end_date)
    end

    @listings = @listings.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
      format.json {render json: @listings.to_json}
    end
  end

  def show
    set_listing
    render_listing_formats
  end

  def edit
    set_listing
    render_listing_formats
  end

  def update
    set_listing
    set_listing.update(listing_params)
    render_listing_formats
  end

  def visualization
    @listings = Listing.all
    render_listings_formats
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.save
    render_listing_formats
  end

  def discriminatory
    @listings = Listing.discriminatory
    render_listings_formats
  end

  def home
  end

  private

  def listing_params
    params.require(:listing).permit(:id, :address, :listed_at, :latitude, :longitude, :description, :discriminatory, :heading)
  end

  def set_listing
    @listing = Listing.find_by(id: params[:id])
  end

  def render_listing_formats
    respond_to do |format|
      format.html
      format.json {render json: @listing.to_json}
    end
  end

  def render_listings_formats
    respond_to do |format|
      format.html
      format.json {render json: @listings.to_json}
    end
  end

end
