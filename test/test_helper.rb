require "simplecov"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/autorun"
require_relative "./remove_uploaded_files"

module ProsopiteTesting
  def before_setup
    super
    Prosopite.scan
  end

  def after_teardown
    Prosopite.finish
    super
  end
end

class ActiveSupport::TestCase
  include ProsopiteTesting
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def attach_file_to_record(record, file_name, content_type)
    record.attach(
      io: File.open(Rails.root.to_s + "/test/fixtures/files/" + file_name),
      filename: file_name,
      content_type: content_type
    )
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ProsopiteTesting
end

class MiniTest::Unit::TestCase
  include ProsopiteTesting
end
