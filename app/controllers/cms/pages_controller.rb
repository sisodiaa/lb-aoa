module CMS
  class PagesController < ApplicationController
    layout "page"

    def show
      if valid_page?
        @show_navbar = true unless sanitized_page_name == "home"
        render template: "cms/pages/#{sanitized_page_name}"
      else
        @show_navbar = false
        render file: "public/404.html", status: :not_found
      end
    end

    private

    def valid_page?
      File.exist?(
        Pathname.new(
          Rails.root + "app/views/cms/pages/#{sanitized_page_name}.html.erb"
        )
      )
    end

    def sanitized_page_name
      /\./i.match?(params[:page]) ? "home" : params[:page].tr("-", "_")
    end
  end
end
