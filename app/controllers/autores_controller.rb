class AutoresController < ApplicationController
  before_action :signed_in_user
  before_action :user_admin

  def index
  	# paginate(page: params[:page])
  	@autores = Autor.paginate(page: params[:page])
  	                
  end

  def destroy
  	Autor.find(params[:id]).destroy
    flash[:success] = "Autor destroy sucessfully."
    redirect_to autores_url
  end

end
