class EditorasController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :new, :edit]
  before_action :user_admin, only: [:index, :show, :new, :edit]

  def index
  	@editoras = Editora.paginate(page: params[:page])
  end

  def show
    @editora = Editora.find(params[:id])
  end

  def new
    @editora = Editora.new
  end

  def edit
    @editora = Editora.find(params[:id])
  end

  def create
    @editora = Editora.new(editora_params)    # Not the final implementation!
    if @editora.save
      flash[:success] = "Editora was sucessfully created"
      redirect_to @editora
    else
      render 'new'
    end
  end

  def update
    @editora = Editora.find(params[:id])
    if @editora.update_attributes(editora_params)
      flash[:success] = "Editora was sucessfully update"
      redirect_to @editora
    else
      render 'edit'
    end
  end

  def destroy
    Editora.find(params[:id]).destroy
    flash[:success] = "Editora destroy sucessfully."
    redirect_to editoras_url
  end

  private
    def editora_params
      params.require(:editora).permit(:descricao, :cidade, :ano)
#      params.require(:assunto).permit(:descricao)     
    end

end
