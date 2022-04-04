module CMS
  class TagsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @tags = Tag.all
    end
  end
end
