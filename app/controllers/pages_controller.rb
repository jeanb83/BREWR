class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @groups = current_user.groups.order(created_at: :desc)
    yesterday = Date.today - 1
    @events = current_user.events.where("date > ?", yesterday).order(date: :asc).limit(5)
  end
end
