class UpdateTitleJob < ApplicationJob
  queue_as :default
  require 'open-uri'

  def perform(short_url_id)
    @url = ShortUrl.find short_url_id
    if @url.present?
      title = Nokogiri::HTML(open(@url.full_url)).css('title').text
      @url.title = title
      @url.save
    end
  end
end
