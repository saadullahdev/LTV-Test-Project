require 'rails_helper'

RSpec.describe UpdateTitleJob, type: :job do
  include ActiveJob::TestHelper

  let(:short_url) { ShortUrl.create(full_url: "https://www.beenverified.com/faq/") }

  it "updates the title" do
    expect(short_url.title).to be_nil
    UpdateTitleJob.perform_later(short_url.id)
    perform_enqueued_jobs(only: UpdateTitleJob)
    short_url.reload
    expect(short_url.title).to eq("Frequently Asked Questions | BeenVerified")
  end

end
