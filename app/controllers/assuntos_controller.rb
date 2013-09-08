class AssuntosController < ApplicationController
  before_action :signed_in_user
  before_action :user_admin

  def index
  	@assuntos = Assunto.paginate(page: params[:page])
  end

  def show
    @assunto = Assunto.find(params[:id])
  end

  def new
    @assunto = Assunto.new
  end

  def edit
    @assunto = Assunto.find(params[:id])
  end

  def create
    @assunto = Assunto.new(assunto_params)    # Not the final implementation!
    if @assunto.save
      flash[:success] = "Assunto was sucessfully created"
      redirect_to @assunto
    else
      render 'new'
    end
  end

  def update
    @assunto = Assunto.find(params[:id])
    if @assunto.update_attributes(assunto_params)
      flash[:success] = "Assunto was sucessfully update."
      #sign_in @user
      redirect_to @assunto
    else
      render 'edit'
    end
  end

  def destroy
  	Assunto.find(params[:id]).destroy
    flash[:success] = "Assunto destroy sucessfully."
    redirect_to assuntos_url
  end

  private
    def assunto_params
      params.require(:assunto).permit(:descricao)    	
    end
end
