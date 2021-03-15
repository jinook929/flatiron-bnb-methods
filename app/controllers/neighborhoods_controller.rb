class NeighborhoodsController < ApplicationController
  before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]

  # GET /neighborhoods
  def index
    @neighborhoods = Neighborhood.all    
    @most_popular = Neighborhood.highest_ratio_res_to_listings
    @most_reserved = Neighborhood.most_res
  end

  # GET /neighborhoods/1
  def show
  end

  # GET /neighborhoods/new
  def new
    @neighborhood = Neighborhood.new
  end

  # GET /neighborhoods/1/edit
  def edit
  end

  # POST /neighborhoods
  def create
    @neighborhood = Neighborhood.new(neighborhood_params)

    if @neighborhood.save
      redirect_to @neighborhood, notice: 'Neighborhood was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /neighborhoods/1
  def update
    if @neighborhood.update(neighborhood_params)
      redirect_to @neighborhood, notice: 'Neighborhood was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /neighborhoods/1
  def destroy
    @neighborhood.destroy
    redirect_to neighborhoods_url, notice: 'Neighborhood was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neighborhood
      @neighborhood = Neighborhood.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def neighborhood_params
      params.require(:neighborhood).permit(:name, :city_id)
    end
end
