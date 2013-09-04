
def full_title(page_title)
  include ApplicationHelper
  base_title = "BBL OnLine - Biblioteca Padre Leonardo"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = Usuario.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, Usuario.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end