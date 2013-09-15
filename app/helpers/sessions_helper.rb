module SessionsHelper

  def sign_in(user)
    remember_token = Usuario.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, Usuario.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token  = Usuario.encrypt(cookies[:remember_token])
    @current_user ||= Usuario.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end
 
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: t(:please_sign_in)
    end
  end

  def user_admin
    unless current_user.admin?
      store_location
      redirect_to signin_url, notice: t(:only_administrator)
    end
  end
end