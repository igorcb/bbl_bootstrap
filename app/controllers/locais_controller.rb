class LocaisController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :new, :edit]
  before_action :user_admin, only: [:index, :show, :new, :edit]

  def index
  	@locais = Local.paginate(page: params[:page])
  end

  def show
    @local = Local.find(params[:id])
  end

  def new
    @local = Local.new
  end

  def edit
    @local = Local.find(params[:id])
  end

  def create
    @local = Local.new(local_params)    # Not the final implementation!
    if @local.save
      flash[:success] = "Local was sucessfully created"
      redirect_to @local
    else
      render 'new'
    end
  end

  def update
    @local = Local.find(params[:id])
    if @local.update_attributes(local_params)
      flash[:success] = "Local was sucessfully update"
      redirect_to @local
    else
      render 'edit'
    end
  end

  def destroy
  	Local.find(params[:id]).destroy
    flash[:success] = "Local destroy sucessfully."
  	redirect_to locais_path
  end

  private
    def local_params
      params.require(:local).permit(:descricao)
    end
end
