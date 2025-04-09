class PagesController < ApplicationController
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!, only: [ :dashboard ]

  def index
  end

  def dashboard
    @dishes = Dish.all
    @preparations = Preparation.all
  end
end
