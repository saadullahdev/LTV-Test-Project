class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)

  end
end
