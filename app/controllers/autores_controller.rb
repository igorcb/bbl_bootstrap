class AutoresController < ApplicationController
  before_action :signed_in_user
  before_action :user_admin

  def index
  	@autores = Autor.paginate(page: params[:page])
  end

  def show
    @autor = Autor.find(params[:id])
  end

  def new
    @autor = Autor.new
  end

  def create
    @autor = Autor.new(autor_params)    # Not the final implementation!
    if @autor.save
      flash[:success] = "Autor was sucessfully created"
      redirect_to @autor
    else
      render 'new'
    end
  end

  def edit
    @autor = Autor.find(params[:id])
  end

  def update
    @autor = Autor.find(params[:id])
    if @autor.update_attributes(autor_params)
      flash[:success] = "Autor was sucessfully update."
      #sign_in @user
      redirect_to @autor
    else
      render 'edit'
    end
  end

  def destroy
  	Autor.find(params[:id]).destroy
    flash[:success] = "Autor destroy sucessfully."
    redirect_to autores_url
  end

  private

    def autor_params
        params.require(:autor).permit(:descricao, :cutter)     
    end

end
