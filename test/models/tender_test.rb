require "test_helper"

class TenderTest < ActiveSupport::TestCase
  setup do
    @draft_tender = tenders(:cctv_cables)
    @draft_tender_without_excel = tenders(:boom_barriers)
    @published_tender = tenders(:air_quality_monitors)
  end

  teardown do
    @draft_tender = @draft_tender_without_excel = @published_tender = nil
  end

  test "that reference_id parameterize reference_token" do
    @draft_tender.reference_token = "AUG/2020-LB/club"
    @draft_tender.save
    assert_equal "aug-2020-lb-club", @draft_tender.reference_id
  end

  test "that reference_token is present" do
    @draft_tender.reference_token = ""
    assert_not @draft_tender.valid?, "Reference Token is required"
  end

  test "that reference_id is unique" do
    new_tender = Tender.new(
      reference_token: @published_tender.reference_token, title: "abc"
    )

    assert_not new_tender.valid?, "Reference Token needs to be unique"
  end

  test "that title is present" do
    @draft_tender.title = ""
    assert_not @draft_tender.valid?, "Title is required"
  end

  test "that description is present" do
    @draft_tender.description = ""
    assert_not @draft_tender.valid?, "Description is missing"
  end

  test "that publish event changes the publication_state" do
    assert @draft_tender.draft?
    assert_not @draft_tender.published?

    @draft_tender.publish

    assert_not @draft_tender.draft?
    assert @draft_tender.published?
  end

  test "that only an upcoming notice gets published" do
    @published_tender.opening = Time.current - 3.days
    assert_raise(AASM::InvalidTransition) { @published_tender.publish }
  end

  test "that manual assignment of publication_state will raise error" do
    assert_raise(AASM::NoDirectAssignmentError) do
      @published_tender.publication_state = :draft
    end
  end

  test "that attachment(s) are required" do
    assert_not @draft_tender_without_excel.valid?(:notice_publication),
      "Attachment(s) are missing"
  end

  test "that opening date is required for publishing the notice" do
    @draft_tender.opening = nil

    assert_not @draft_tender.valid?(:notice_publication), "Opening date is missing"
  end

  test "that closing date is required for publishing the notice" do
    @draft_tender.closing = nil

    assert_not @draft_tender.valid?(:notice_publication), "Closing date is missing"
  end

  test "that opening datetime should be before closing datetime" do
    @draft_tender.opening = @draft_tender.closing + 3.days

    assert_not @draft_tender.valid?(:notice_publication),
      "Opening date & time should come before closing date & time"
  end

  test "set opening to nil for invaid datetime" do
    @published_tender.opens_on = "2001-02-36 14:05"
    assert_nil @published_tender.opening
  end

  test "set closing to nil for invaid datetime" do
    @published_tender.closes_on = "2001-22-30 14:05"
    assert_nil @published_tender.closing
  end

  test "that publishing a notice sets the published_at" do
    assert_nil @draft_tender.published_at

    @draft_tender.publish

    assert_equal DateTime.current.to_i, @draft_tender.published_at.to_i
  end
end
