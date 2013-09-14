require 'spec_helper'

describe "Classificacoes Pagina" do
  subject { page }

  describe "index" do
    describe "deve estar logado" do
  	  before { visit classificacoes_path }

  	  it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
	  	let(:usuario) { FactoryGirl.create(:usuario) }
  	  before(:each) do
  	  	sign_in usuario
  	    visit classificacoes_path 
  	  end

  	  it { should have_content('administradores') }
    end

    
    describe "como usuario administrador" do
   	  let(:usuario) { FactoryGirl.create(:admin) }

    	before(:each) do
    		sign_in usuario
  	    visit classificacoes_path
      end

      it { should have_title('Classificações') }
      it { should have_content('All classificações') }
      it { should have_link('New classificação', href: new_classificacao_path) }

      describe "paginations" do
	      before(:all) { 35.times { FactoryGirl.create(:classificacao) } } 
	      after(:all)  { Classificacao.delete_all}

	      it { should have_selector('div.pagination') }

	      it "deve listar cada classificacao" do
	        Classificacao.paginate(page: 1).each do |classificacao|
	          expect(page).to have_selector('td', text: classificacao.cdd)
	          expect(page).to have_selector('td', text: classificacao.descricao)
	        end
	      end
      end

      describe "delete links" do
        let(:admin) { FactoryGirl.create(:admin) }

        before { FactoryGirl.create(:classificacao) }
        
        before do
          sign_in admin
       	  visit classificacoes_path
        end
      
        it { should have_link('Delete', href: classificacao_path(Classificacao.first)) }

        it "deve ser capaz de apagar classificacao" do
          expect do
            click_link('Delete', match: :first)
          end.to change(Classificacao, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end

      describe "edit links" do
        let(:admin) { FactoryGirl.create(:admin) }
         
        before { @classificacao = Classificacao.create(descricao: "classificacao Exemplo", cdd: "000.10") }
        after(:all)  { Classificacao.delete_all}
       
        before do
          sign_in admin
          visit classificacoes_path
        end
    
        it { should have_link('Edit', href: edit_classificacao_path(@classificacao)) }
      end

    end
  end

  describe "show page" do
  
    describe "deve estar logado" do
      let(:classificacao) { FactoryGirl.create(:classificacao) }
      before { visit classificacao_path(classificacao) }

      it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:classificacao) { FactoryGirl.create(:classificacao) }

      before(:each) do
        sign_in usuario
        visit classificacao_path(classificacao) 
      end

      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:classificacao) { FactoryGirl.create(:classificacao) }

      before do
        sign_in usuario
        visit classificacao_path(classificacao) 
      end

      it { should have_title(classificacao.cdd) }
      it { should have_content(classificacao.cdd) }
      it { should have_content(classificacao.descricao) }
      it { should have_selector('div.form-actions') }
      it { should have_link('New', href: new_classificacao_path) }
      it { should have_link('Edit', href: edit_classificacao_path(classificacao)) }
      it { should have_link('All', href: classificacoes_path) }
    end
  end

  describe "nova classificacao" do
    describe "deve estar logado" do
      let(:classificacao) { FactoryGirl.create(:autor) }
      before { visit new_classificacao_path  }

      it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:classificacao) { FactoryGirl.create(:classificacao) }

      before(:each) do
        sign_in usuario
        visit new_classificacao_path(classificacao) 
      end

      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }

      before do
        sign_in usuario
        visit new_classificacao_path 
      end
      it { should have_content("New classificacao") }
      it { should have_title("New classificacao") }
      it { should have_selector('div.form-actions') }
      it { should have_link("Cancel", href: classificacoes_path) }

      let(:submit) { "Save classificacao" }

      describe "com informacoes invalidas" do
        it "nao deve criar um classificacao" do
          expect { click_button submit }.not_to change(Classificacao, :count)
        end
      end
      
      describe "com informacoes validas" do
        let(:novo_classificacao) { 'Exemplo classificacao' }
        let(:novo_cdd) { '000.01' }
        before do
          fill_in "Descricao",         with: novo_classificacao
          fill_in "Cdd",            with: novo_cdd
        end

        it "deve criar um classificacao" do
          expect { click_button submit }.to change(Classificacao, :count).by(1)
        end

        describe "depois de salvar a classificacao" do
          before { click_button submit }
          let(:classificacao) { Classificacao.find_by(descricao: novo_classificacao, cdd: novo_cdd) }

          #it { should have_link('Sign out') }
          it { should have_title(classificacao.cdd) }
          it { should have_content(classificacao.cdd) }
          it { should have_content(classificacao.descricao) }
          it { should have_selector('div.alert.alert-success', text: 'sucessfully created') }
        end
      end
    end
  end

  describe "editar" do
    describe "deve estar logado" do
      let(:classificacao) { FactoryGirl.create(:classificacao) }
      before { visit edit_classificacao_path(:classificacao)  }

      it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:classificacao) { FactoryGirl.create(:classificacao) }

      before(:each) do
        sign_in usuario
        visit edit_classificacao_path(classificacao) 
      end

      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:classificacao) { FactoryGirl.create(:classificacao) }
      
      before do
        sign_in usuario
        visit edit_classificacao_path(classificacao)
      end

      it { should have_content('Edit classificação') }
      it { should have_title('Edit classificação') }
      it { should have_selector('div.form-actions') }
      it { should have_link("Cancel", href: classificacoes_path) }

      describe "com informacoes invalidas" do
        before do 
          fill_in "Descricao",             with: ""
          fill_in "Cdd",                   with: ""
          click_button "Save changes" 
        end

        it { should have_content("error") }
      end

      describe "com informacao vaidas" do
        let(:new_classificacao)  { "Novo classificacoa" }
        let(:new_cdd)  { '000.01' }
        before do
          fill_in "Descricao",             with: new_classificacao
          fill_in "Cdd",             with: new_cdd
          click_button "Save changes"
        end

        it { should have_title(new_cdd) }
        it { should have_content(new_classificacao) }
        it { should have_content(new_cdd) }
        it { should have_selector('div.alert.alert-success') }
        #it { should have_link('Sign out', href: signout_path) }
        specify { expect(classificacao.reload.descricao).to  eq new_classificacao }
        specify { expect(classificacao.reload.cdd).to  eq new_cdd }
      end
    end

  end


end
