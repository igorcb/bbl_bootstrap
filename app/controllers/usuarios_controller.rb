class UsuariosController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @usuarios = Usuario.paginate(page: params[:page])
  end

  def show
  	@user = Usuario.find(params[:id])
  end

  def new
  	@user = Usuario.new
  end

  def edit
    @user = Usuario.find(params[:id])
  end

  def create
    @user = Usuario.new(user_params)    # Not the final implementation!
    if @user.save
      flash[:success] = "Bem vindo to the BBL OnLine!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = Usuario.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    Usuario.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to usuarios_url
  end

  private
    def user_params
      params.require(:usuario).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = Usuario.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
