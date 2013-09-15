require 'spec_helper'

describe "Autores Paginas" do
  subject { page }

  describe "index" do

    describe "deve estar logado" do
  	  before { visit autores_path }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
	  	let(:usuario) { FactoryGirl.create(:usuario) }
  	  before(:each) do
  	  	sign_in usuario
  	    visit autores_path 
  	  end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
   	  let(:usuario) { FactoryGirl.create(:admin) }

    	before(:each) do
    		sign_in usuario
  	    visit autores_path
      end

      it { should have_title('Autores') }
      it { should have_content(I18n.t('views.listing') + ' autor') }
      it { should have_link(I18n.t('views.new') + ' autor', href: new_autor_path) }

      describe "paginations" do
	      before(:all) { 35.times { FactoryGirl.create(:autor) } } 
	      after(:all)  { Autor.delete_all}

	      it { should have_selector('div.pagination') }

	      it "deve listar cada autor" do
	        Autor.paginate(page: 1).each do |autor|
	          expect(page).to have_selector('td', text: autor.descricao)
	          expect(page).to have_selector('td', text: autor.cutter)
	        end
	      end
      end

      describe "delete links" do
        let(:admin) { FactoryGirl.create(:admin) }

        before { FactoryGirl.create(:autor) }
        
        before do
          sign_in admin
       	  visit autores_path
        end
      
        it { should have_link(I18n.t('views.destroy'), href: autor_path(Autor.first)) }

        it "deve ser capaz de apagar autor" do
          expect do
            click_link(I18n.t('views.destroy'), match: :first)
          end.to change(Autor, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end

      describe "edit links" do
        let(:admin) { FactoryGirl.create(:admin) }
         
        before { @autor = Autor.create(descricao: "Autor Exemplo", cutter: "01.01") }
        after(:all)  { Autor.delete_all}
       
        before do
          sign_in admin
          visit autores_path
        end
    
        it { should have_link(I18n.t('views.edit'), href: edit_autor_path(@autor)) }
      end
    end
  end

  describe "show page" do
  
    describe "deve estar logado" do
      let(:autor) { FactoryGirl.create(:autor) }
      before { visit autor_path(autor) }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:autor) { FactoryGirl.create(:autor) }

      before(:each) do
        sign_in usuario
        visit autor_path(autor) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:autor) { FactoryGirl.create(:autor) }

      before do
        sign_in usuario
        visit autor_path(autor) 
      end

      it { should have_content(autor.descricao) }
      it { should have_content(autor.cutter) }
      it { should have_title(autor.descricao) }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t('views.new'), href: new_autor_path) }
      it { should have_link(I18n.t('views.edit'), href: edit_autor_path(autor)) }
      it { should have_link(I18n.t('views.list'), href: autores_path) }
    end
  end

  describe "novo autor" do
    describe "deve estar logado" do
      let(:autor) { FactoryGirl.create(:autor) }
      before { visit new_autor_path  }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:autor) { FactoryGirl.create(:autor) }

      before(:each) do
        sign_in usuario
        visit new_autor_path(autor) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }

      before do
        sign_in usuario
        visit new_autor_path 
      end
      it { should have_title(I18n.t('views.new') + ' autor') }
      it { should have_content(I18n.t('views.new') + ' autor') }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t("views.cancel"), href: autores_path) }

      let(:submit) { I18n.t("views.save") }

      describe "com informacoes invalidas" do
        it "nao deve criar um autor" do
          expect { click_button submit }.not_to change(Autor, :count)
        end
      end
      
      describe "com informacoes validas" do
        let(:novo_autor) { 'Exemplo Autor' }
        let(:novo_cutter) { '11.91' }
        before do
          fill_in "Descricao",         with: novo_autor
          fill_in "Cutter",            with: novo_cutter
        end

        it "deve criar um autor" do
          expect { click_button submit }.to change(Autor, :count).by(1)
        end

        describe "depois de salvar a autor" do
          before { click_button submit }
          let(:autor) { Autor.find_by(descricao: novo_autor, cutter: novo_cutter) }

          #it { should have_link('Sign out') }
          it { should have_title(autor.descricao) }
          it { should have_content(autor.descricao) }
          it { should have_content(autor.cutter) }
          it { should have_selector('div.alert.alert-success', text: 'sucessfully created') }
        end
      end
    end
  end

  describe "editar" do
    describe "deve estar logado" do
      let(:autor) { FactoryGirl.create(:autor) }
      before { visit edit_autor_path(:autor)  }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:autor) { FactoryGirl.create(:autor) }

      before(:each) do
        sign_in usuario
        visit edit_autor_path(autor) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:autor) { FactoryGirl.create(:autor) }
      
      before do
        sign_in usuario
        visit edit_autor_path(autor)
      end
      it { should have_content(I18n.t('views.edit') + ' autor') }
      it { should have_title(I18n.t('views.edit') + ' autor') }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t("views.cancel"), href: autores_path) }

      describe "com informacoes invalidas" do
        before do 
          fill_in "Descricao",             with: ""
          fill_in "Cutter",                with: ""
          click_button I18n.t("views.update")
        end

        it { should have_content("error") }
      end

      describe "com informacao vaidas" do
        let(:new_autor)  { "Novo Autor" }
        let(:new_cutter)  { "00.01" }
        before do
          fill_in "Descricao",             with: new_autor
          fill_in "Cutter",             with: new_cutter
          click_button I18n.t("views.update")
        end

        it { should have_title(new_autor) }
        it { should have_content(new_autor) }
        it { should have_content(new_cutter) }
        it { should have_selector('div.alert.alert-success') }
        #it { should have_link('Sign out', href: signout_path) }
        specify { expect(autor.reload.descricao).to  eq new_autor }
        specify { expect(autor.reload.cutter).to  eq new_cutter }
      end
    end

  end

end
