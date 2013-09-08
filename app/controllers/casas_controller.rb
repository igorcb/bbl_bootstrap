class CasasController < ApplicationController
  before_action :signed_in_user
  before_action :user_admin

  def index
  	@casas = Casa.paginate(page: params[:page])
  end

  def show
    @casa = Casa.find(params[:id])
  end

  def new
    @casa = Casa.new
  end

  def edit
    @casa = Casa.find(params[:id])
  end

  def create
    @casa = Casa.new(casa_params)    # Not the final implementation!
    if @casa.save
      flash[:success] = "Casa was sucessfully created"
      redirect_to @casa
    else
      render 'new'
    end
  end

  def update
    @casa = Casa.find(params[:id])
    if @casa.update_attributes(casa_params)
      flash[:success] = "Casa was sucessfully update."
      redirect_to @casa
    else
      render 'edit'
    end
  end

  def destroy
  	@casa = Casa.find(params[:id]).destroy
    flash[:success] = "Casa destroy sucessfully."
    redirect_to casas_path
  end

  private
    def casa_params
      params.require(:casa).permit(:descricao)    	
    end
end
