class ClassificacoesController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :new, :edit]
  before_action :user_admin, only: [:index, :show, :new, :edit]

  def index
    @classificacoes = Classificacao.paginate(page: params[:page])
  end

  def show
  	@classificacao = Classificacao.find(params[:id])
  end

  def new
  	@classificacao = Classificacao.new
  end

  def create
    @classificacao = Classificacao.new(classificacao_params)    # Not the final implementation!
    if @classificacao.save
      flash[:success] = "Classificação was sucessfully created"
      redirect_to @classificacao
    else
      render 'new'
    end
  end

  def edit
  	@classificacao = Classificacao.find(params[:id])
  end

  def update
    @classificacao = Classificacao.find(params[:id])
    if @classificacao.update_attributes(classificacao_params)
      flash[:success] = "Classificacao was sucessfully update."
      #sign_in @user
      redirect_to @classificacao
    else
      render 'edit'
    end
  end  

  def destroy
  	Classificacao.find(params[:id]).destroy
    flash[:success] = "Classificação destroy sucessfully."
    redirect_to classificacoes_url
  end

  private
    def classificacao_params
    	params.require(:classificacao).permit(:cdd, :descricao) 
    end

end
