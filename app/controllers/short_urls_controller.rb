class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @top_urls = ShortUrl.top_urls.pluck(:full_url)
    
    render json: { urls: @top_urls }, status: :ok
  end

  def create
    if params[:full_url].present?
      @short_url = ShortUrl.new full_url: params[:full_url]

      if @short_url.save
        render json: { short_code: @short_url.short_code }, status: :ok
      else
        render json: { errors: @short_url.errors.full_messages.first }, status: :unprocessable_entity
      end
    end
  end

  def show
    if params[:id].present?
      @url = ShortUrl.find_by_short_code params[:id]

      if @url.present?
        @url.click_count += 1
        @url.save
        redirect_to @url.full_url
      else
        render json: {}, status: :not_found
      end
    end
  end

end
