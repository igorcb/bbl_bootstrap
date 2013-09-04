require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      #it { should have_error_message('Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      # before do
      #   fill_in "Email",    with: user.email.upcase
      #   fill_in "Password", with: user.password
      #   click_button "Sign in"
      # end
      before { sign_in usuario }

      it { should have_title(usuario.name) }
      it { should have_link('Users',       href: usuarios_path) }
      it { should have_link('Profile',     href: usuario_path(usuario)) }
      it { should have_link('Settings',    href: edit_usuario_path(usuario)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:usuario) { FactoryGirl.create(:usuario) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_usuario_path(usuario)
          fill_in "Email",    with: usuario.email
          fill_in "Password", with: usuario.password
          click_button "Sign in"
        end

        describe "after signing in" do

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: usuario.email
              fill_in "Password", with: usuario.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(usuario.name)
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_usuario_path(usuario) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch usuario_path(usuario) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit usuarios_path }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as wrong user" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:wrong_user) { FactoryGirl.create(:usuario, email: "wrong@example.com") }
      before { sign_in usuario, no_capybara: true }

      describe "visiting Users#edit page" do
        before { visit edit_usuario_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch usuario_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:non_admin) { FactoryGirl.create(:usuario) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete usuario_path(usuario) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

  end
end
