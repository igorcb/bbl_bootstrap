class LivrosController < ApplicationController
	before_action :signed_in_user, only: [:index, :show, :new, :edit, :update]
  before_action :user_admin, only: [:index, :show, :new, :edit, :update]

  def index
    @livros = Livro.paginate(page: params[:page])
  end

  def show
    @livro = Livro.find(params[:id])
  end

  def new
    @livro = Livro.new
  end

  def edit
    @livro = Livro.find(params[:id])
  end

  def create
  	@livro = Livro.new(livro_params)
  	if @livro.save
  		flash[:success] = "Livro was sucessfully created"
      redirect_to @livro
    else
      render 'new'
    end
  end

  def update
    @livro = Livro.find(params[:id])
    if @livro.update_attributes(livro_params)
      flash[:success] = "Livro was sucessfully update."
      redirect_to @livro
    else
      render 'edit'
    end
  end

  def destroy
  	Livro.find(params[:id]).destroy
  	flash[:success] = "Livro destroy successfully."
    redirect_to livros_path  	                         
  end

  private
    def livro_params
    	params.require(:livro).permit(:casa_id, :autor_id, :editora_id, :local_id, :assunto_id, :classificacao_id,
    		                            :descricao, :isbn, :cutter, :edicao, :ano, :paginas, :localizacao)
    end
end
