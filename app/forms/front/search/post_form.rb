module Front
  module Search
    class PostForm
      include ActiveModel::Model

      attr_accessor :category_id, :tags_list, :start_date, :end_date

      def initialize(attributes = {})
        @category_id = attributes.fetch(:category_id, "")
        @tags_list = attributes.fetch(:tags_list, "")
        @start_date = attributes.fetch(:start_date, "").to_date
        @end_date = attributes.fetch(:end_date, "").to_date
      end

      def search
        results
      end

      def results
        records = Post.published.includes(:category, :rich_text_content, :tags, :taggings)
        records = records.published_between(start_date, end_date) if start_date.present? || end_date.present?
        records = records.with_category(category_id.to_i) if category_id.present?
        records = records.with_tags(tags) if tags.present?

        records
      end

      def tags
        tags_list.split(",").collect(&:strip).reject(&:empty?).collect(&:downcase).uniq
      end

      # Validations

      validate :date_range
      validate :number_of_tags

      def date_range
        errors.add(:start_date, "should be before end date") if start_date_after_end_date?
      end

      def number_of_tags
        errors.add(:tags_list, "should not have more than 3 tags") if tags.length > 3
      end

      def start_date_after_end_date?
        start_date && end_date && (start_date > end_date)
      end

      def policy_class
        Front::SearchPolicy
      end
    end
  end
end
