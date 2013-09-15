require 'spec_helper'

describe "Locais Pagina" do
	subject { page }

  describe "index" do

    describe "deve estar logado" do
      before { visit locais_path }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

		describe "como um usuario comum" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before(:each) do
        sign_in usuario
        visit locais_path
      end
 
      it { should have_content(I18n.t(:only_administrator)) }
		end

		describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
     	
     	before(:each) do
    	  sign_in usuario
    	  visit locais_path
      end
    	it { should have_title('Locais') }
      it { should have_content(I18n.t('views.listing') + ' locais') }
      it { should have_link(I18n.t('views.new') , href: new_local_path ) }

      describe "paginations" do
        before(:all) { 35.times { FactoryGirl.create(:local) } } 
        after(:all)  { Local.delete_all}

        it { should have_selector('div.pagination') }

        it "deve listar cada local" do
         Local.paginate(page: 1).each do |local|
           expect(page).to have_selector('td', text: local.descricao)
         end
        end
      end

      describe "delete links" do
        let(:admin) { FactoryGirl.create(:admin) }

        before { FactoryGirl.create(:local) }
        
        before do
          sign_in admin
          visit locais_path
        end
      
        it { should have_link(I18n.t('views.destroy'), href: local_path(Local.first)) }

        it "deve ser capaz de apagar local" do
          expect do
            click_link(I18n.t('views.destroy'), match: :first)
          end.to change(Local, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end

      describe "edit links" do
        let(:admin) { FactoryGirl.create(:admin) }
         
        before { @local = Local.create(descricao: "Local Exemplo") }
        after(:all)  { Local.delete_all}
       
        before do
          sign_in admin
          visit locais_path
        end
    
        it { should have_link(I18n.t('views.edit'), href: edit_local_path(@local)) }
      end
		end
  end

  describe "show page" do
  
    describe "deve estar logado" do
      let(:local) { FactoryGirl.create(:local) }
      before { visit local_path(local) }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:local) { FactoryGirl.create(:local) }

      before(:each) do
        sign_in usuario
        visit local_path(local) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:local) { FactoryGirl.create(:local) }

      before do
        sign_in usuario
        visit local_path(local) 
      end

      it { should have_content(local.descricao) }
      it { should have_title(local.descricao) }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t('views.new'), href: new_local_path) }
      it { should have_link(I18n.t('views.edit'), href: edit_local_path(local)) }
      it { should have_link(I18n.t('views.list'), href: locais_path) }
    end
  end

  describe "novo local" do
    describe "deve estar logado" do
      let(:local) { FactoryGirl.create(:local) }
      before { visit new_local_path  }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:local) { FactoryGirl.create(:local) }

      before(:each) do
        sign_in usuario
        visit new_local_path(local) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }

      before do
        sign_in usuario
        visit new_local_path 
      end
      it { should have_content(I18n.t('views.new') + ' local') }
      it { should have_title(I18n.t('views.new') + ' local') }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t('views.cancel'), href: locais_path) }

      let(:submit) { I18n.t("views.save") }

      describe "com informacoes invalidas" do
        it "nao deve criar um local" do
          expect { click_button submit }.not_to change(Local, :count)
        end
      end
      
      describe "com informacoes validas" do
        let(:novo_local) { 'Exemplo local' }
        before do
          fill_in "Descricao",         with: novo_local
        end

        it "deve criar um local" do
          expect { click_button submit }.to change(Local, :count).by(1)
        end

        describe "depois de salvar a local" do
          before { click_button submit }
          let(:local) { Local.find_by(descricao: novo_local) }

          #it { should have_link('Sign out') }
          it { should have_title(local.descricao) }
          it { should have_content(local.descricao) }
          it { should have_selector('div.alert.alert-success', text: 'sucessfully created') }
        end
      end
    end
  end

  describe "editar" do
    describe "deve estar logado" do
      let(:local) { FactoryGirl.create(:local) }
      before { visit edit_local_path(:local)  }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:local) { FactoryGirl.create(:local) }

      before(:each) do
        sign_in usuario
        visit edit_local_path(local) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:local) { FactoryGirl.create(:local) }
      
      before do
        sign_in usuario
        visit edit_local_path(local)
      end
      it { should have_content(I18n.t('views.edit') + ' local') }
      it { should have_title(I18n.t('views.edit') + ' local') }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t("views.cancel"), href: locais_path) }

      describe "com informacoes invalidas" do
        before do 
          fill_in "Descricao",             with: ""
          click_button I18n.t("views.update")
        end

        it { should have_content("error") }
      end

      describe "com informacao vaidas" do
        let(:new_local)  { "Novo local" }
        before do
          fill_in "Descricao",             with: new_local
          click_button I18n.t("views.update")
        end

        it { should have_title(new_local) }
        it { should have_content(new_local) }
        it { should have_selector('div.alert.alert-success') }
        #it { should have_link('Sign out', href: signout_path) }
        specify { expect(local.reload.descricao).to  eq new_local }
      end
    end

  end

end
