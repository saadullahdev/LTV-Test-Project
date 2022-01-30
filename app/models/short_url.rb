class ShortUrl < ApplicationRecord
  require 'uri'

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url


  scope :top_urls, -> { order(:click_count).limit(100) }

  def short_code
    if valid?
      "#{self.id/1000}-#{self.id%1000}-"
    end
  end

  def self.find_by_short_code code
    id = get_decoded_id code
    find_by(id: id)
  end

  def self.get_decoded_id code
    data = code.split("-")
    return "" if data.count != 2

    (data.first.to_i * 1000) + (data.second.to_i)
  end

  def update_title!
    UpdateTitleJob.perform_now self.id
  end

  private

  def validate_full_url
    unless full_url.present?
      errors.add(:full_url, "can't be blank")
      return
    end
    begin
      uri = URI.parse(full_url)
      unless uri.is_a?(URI::HTTP) && !uri.host.nil?
        errors.add(:full_url, 'is not a valid url')
      end
    rescue URI::InvalidURIError
      errors.add(:full_url, 'is not a valid url')
    end
  end

end
