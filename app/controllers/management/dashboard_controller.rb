module Management
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index; end

    def posts; end

    def tenders; end
  end
end
