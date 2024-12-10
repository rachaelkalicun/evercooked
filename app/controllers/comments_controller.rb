class CommentsController < ApplicationController
  before_action :set_dish

  def create
    @dish.comments.create! params.expect(comment: [ :content ])
    redirect_to @dish
  end

  private
    def set_dish
      @dish = Dish.find(params[:dish_id])
    end
end
