require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "index" do
    describe "deve estar logado" do
      before { visit usuarios_path }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como um usuario comum" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before(:each) do
        sign_in usuario
        visit usuarios_path
      end
 
      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }

      before(:each) do
        sign_in usuario
        visit usuarios_path
      end

      it { should have_title('All users') }
      it { should have_content('All users') }

      describe "pagination" do

        before(:all) { 30.times { FactoryGirl.create(:usuario) } }
        after(:all)  { Usuario.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each user" do
          Usuario.paginate(page: 1).each do |user|
            expect(page).to have_selector('li', text: user.email)
          end
        end
      end

      describe "delete links" do

        it { should_not have_link('delete') }

        describe "as an admin user" do
          let(:admin) { FactoryGirl.create(:admin) }
          before do
            sign_in admin
            visit usuarios_path
          end

          it { should have_link('delete', href: usuario_path(Usuario.first)) }
          it "should be able to delete another user" do
            expect do
              click_link('delete', match: :first)
            end.to change(Usuario, :count).by(-1)
          end
          it { should_not have_link('delete', href: usuario_path(admin)) }
        end
      end

    end

  end

  describe "profile page" do
    describe "deve estar logado" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before { visit usuario_path(usuario) }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario logado" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      
      before do
        sign_in usuario
        visit usuario_path(usuario) 
      end

      it { should have_title(usuario.email) }
      it { should have_content(usuario.name) }
      it { should have_content(usuario.email) }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t('views.edit'), href: edit_usuario_path(usuario)) }
      it { should have_link(I18n.t('views.list'), href: usuarios_path) }
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(Usuario, :count)
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(Usuario, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:usuario) { Usuario.find_by(email: 'user@example.com') }

        #it { should have_link('Sign out') }
        it { should have_title(usuario.email) }
        it { should have_selector('div.alert.alert-success', text: 'Bem vindo') }
      end
    end
  end

  describe "edit" do
    describe "deve estar logado" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before { visit edit_usuario_path(usuario) }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario logado " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before do
        sign_in usuario
        visit edit_usuario_path(usuario)
      end

      describe "page" do
        it { should have_content("Update your profile") }
        it { should have_title("Edit user") }
        it { should have_link('change', href: 'http://gravatar.com/emails') }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content('error') }
      end

      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: usuario.password
          fill_in "Confirm Password", with: usuario.password
          click_button "Save changes"
        end

        it { should have_title(new_email) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { expect(usuario.reload.name).to  eq new_name }
        specify { expect(usuario.reload.email).to eq new_email }
      end
    
      describe "forbidden attributes" do
        let(:params) do
          { usuario: { admin: true, password: usuario.password,
                    password_confirmation: usuario.password } }
        end
        before { patch usuario_path(usuario), params }
        specify { expect(usuario.reload).not_to be_admin }
      end
      
    end

  end
end
