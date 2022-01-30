class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @top_urls = ShortUrl.top_urls.pluck(:full_url)
    render json: { urls: @top_urls }, status: :ok
  end

  def create
    @short_url = ShortUrl.find_or_create_by(full_url: short_url_params)
    if @short_url.save
      render json: { short_code: @short_url.short_code }, status: :ok
    else
      render json: { errors: @short_url.errors.full_messages.first }, status: :unprocessable_entity
    end
  end

  def show
    @url = ShortUrl.find_by_short_code short_code_params
    if @url.present?
      @url.click_count += 1
      @url.save
      redirect_to @url.full_url
    else
      render json: {}, status: :not_found
    end
  end

  private

  def short_url_params
    params[:full_url]
  end

  def short_code_params
    params[:id]
  end

end
