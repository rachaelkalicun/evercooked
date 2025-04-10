class DishesController < ApplicationController
  before_action :set_dish, only: %i[ show edit update destroy ]
  after_action :verify_authorized, except: %i[ index show ]

  # GET /dishes or /dishes.json
  def index
    @dishes = Dish.all
  end

  # GET /dishes/1 or /dishes/1.json
  def show
  end

  # GET /dishes/new
  def new
    @dish = Dish.new
    authorize @dish
  end

  # GET /dishes/1/edit
  def edit
    authorize @dish
  end

  # POST /dishes or /dishes.json
  def create
    @dish = Dish.new(dish_params)
    authorize @dish
    @dish.user = current_user

    respond_to do |format|
      if @dish.save
        format.html { redirect_to @dish, notice: "Dish was successfully created." }
        format.json { render :show, status: :created, location: @dish }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dishes/1 or /dishes/1.json
  def update
    authorize @dish
    respond_to do |format|
      if @dish.update(dish_params)
        format.html { redirect_to @dish, notice: "Dish was successfully updated." }
        format.json { render :show, status: :ok, location: @dish }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dishes/1 or /dishes/1.json
  def destroy
    authorize @dish
    @dish.destroy!

    respond_to do |format|
      format.html { redirect_to dishes_path, status: :see_other, notice: "Dish was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_dish
      @dish = Dish.find(params.require(:id))
    end

    def dish_params
      params.require(:dish).permit(:name, :description)
    end
end
