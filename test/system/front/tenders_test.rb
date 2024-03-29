require "application_system_test_case"

module Front
  class TendersTest < ApplicationSystemTestCase
    setup do
      @published_tender = tenders(:air_quality_monitors)
    end

    teardown do
      @published_tender = nil
    end

    test "#show tender cotent and attachments" do
      @published_tender.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end
      visit tender_url(@published_tender)

      assert_selector "h1", text: @published_tender.title
      assert_selector ".trix-content"
      assert_selector "turbo-frame#attachments li", count: 1
    end

    test "dropdown for selecting tenders by their status types" do
      visit upcoming_tenders_url
      assert_selector ".tender", count: 1
      within(".tender") do
        assert_selector "h1", text: "supply air quality monitors"
      end

      click_button "List Tenders by Status"
      click_link "Current"

      assert_selector ".tender", count: 1
      within(".tender") do
        assert_selector "h1", text: "Barb wire for fencing"
      end

      click_button "List Tenders by Status"
      click_link "Under Review"

      assert_selector ".tender", count: 1
      within(".tender") do
        assert_selector "h1", text: "Installation for water purifier for each tower"
      end

      click_button "List Tenders by Status"
      click_link "Reviewed"

      assert_selector ".tender", count: 1
      within(".tender") do
        assert_selector "h1", text: "Replacement of elevator buttons"
      end
    end
  end
end
