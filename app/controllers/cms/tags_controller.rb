module CMS
  class TagsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @tags = Tag.where.associated(:posts).load_async
      @orphaned_tags = Tag.where.missing(:posts).load_async
      @orphaned_tags.destroy_all if @orphaned_tags.present?
    end
  end
end
