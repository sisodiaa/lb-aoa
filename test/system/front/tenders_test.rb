require "application_system_test_case"

module Front
  class TendersTest < ApplicationSystemTestCase
    setup do
      @published_tender = tenders(:air_quality_monitors)
    end

    teardown do
      @published_tender = nil
    end

    test "#show post cotent and attachments" do
      @published_tender.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end
      visit tender_url(@published_tender)

      assert_selector "h1", text: @published_tender.title
      assert_selector ".trix-content"
      assert_selector "turbo-frame#attachments li", count: 1
    end

    test "#index" do
      skip
      visit posts_url
      assert_selector ".post-skeleton"
      assert_selector ".post", count: 6

      click_link "Next"
      assert_selector ".post-skeleton"
      assert_selector ".post", count: 3
    end
  end
end
