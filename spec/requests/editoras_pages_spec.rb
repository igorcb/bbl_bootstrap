require 'spec_helper'

describe "Editoras Paginas" do
  subject { page }

  describe "index" do
    describe "deve estar logado" do
  	  before { visit editoras_path }

  	  it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
	  	let(:usuario) { FactoryGirl.create(:usuario) }
  	  before(:each) do
  	  	sign_in usuario
  	    visit editoras_path 
  	  end

  	  it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
   	  let(:usuario) { FactoryGirl.create(:admin) }

    	before(:each) do
    		sign_in usuario
  	    visit editoras_path
      end

      it { should have_title('Editoras') }
      it { should have_content('All editoras') }
      it { should have_link('New editora') }

      describe "paginations" do
	      before(:all) { 35.times { FactoryGirl.create(:editora) } } 
	      after(:all)  { Editora.delete_all}

	      it { should have_selector('div.pagination') }

	      it "deve listar cada editora" do
	        Editora.paginate(page: 1).each do |editora|
	          expect(page).to have_selector('td', text: editora.descricao)
	          expect(page).to have_selector('td', text: editora.cidade)
	          expect(page).to have_selector('td', text: editora.ano)
	        end
	      end
      end

      describe "delete links" do
        let(:admin) { FactoryGirl.create(:admin) }

        before { FactoryGirl.create(:editora) }
        
        before do
          sign_in admin
       	  visit editoras_path
        end
      
        it { should have_link('Delete', href: editora_path(Editora.first)) }

        it "deve ser capaz de apagar editora" do
          expect do
            click_link('Delete', match: :first)
          end.to change(Editora, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end

      describe "edit links" do
        let(:admin) { FactoryGirl.create(:admin) }
         
        before { @editora = Editora.create(descricao: "Editora Exemplo", cidade: "Fortaleza", ano: "1990") }
        after(:all)  { Editora.delete_all}
       
        before do
          sign_in admin
          visit editoras_path
        end
    
        it { should have_link('Edit', href: edit_editora_path(@editora)) }
      end
    end
  end

  describe "show page" do
  
    describe "deve estar logado" do
      let(:editora) { FactoryGirl.create(:editora) }
      before { visit editora_path(editora) }

      it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:editora) { FactoryGirl.create(:editora) }

      before(:each) do
        sign_in usuario
        visit editora_path(editora) 
      end

      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:editora) { FactoryGirl.create(:editora) }

      before do
        sign_in usuario
        visit editora_path(editora) 
      end

      it { should have_content(editora.descricao) }
      it { should have_content(editora.cidade) }
      it { should have_content(editora.ano) }
      it { should have_title(editora.descricao) }
    end
  end

  describe "nova editora" do
    describe "deve estar logado" do
      let(:editora) { FactoryGirl.create(:editora) }
      before { visit new_editora_path  }

      it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:editora) { FactoryGirl.create(:editora) }

      before(:each) do
        sign_in usuario
        visit new_editora_path(editora) 
      end

      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }

      before do
        sign_in usuario
        visit new_editora_path 
      end

      it { should have_content("New editora") }
      it { should have_title("New editora") }
      it { should have_link("Cancel", href: editoras_path) }

      let(:submit) { "Save editora" }

      describe "com informacoes invalidas" do
        it "nao deve criar um editora" do
          expect { click_button submit }.not_to change(Editora, :count)
        end
      end
      
      describe "com informacoes validas" do
        let(:nova_editora) { 'Exemplo editora' }
        let(:nova_cidade) { 'Fortaleza' }
        let(:novo_ano) { '1990' }
        before do
          fill_in "Descricao",         with: nova_editora
          fill_in "Cidade",            with: nova_cidade
          fill_in "Ano",            with: novo_ano
        end

        it "deve criar um editora" do
          expect { click_button submit }.to change(Editora, :count).by(1)
        end

        describe "depois de salvar a editora" do
          before { click_button submit }
          let(:editora) { Editora.last }

          #it { should have_link('Sign out') }
          it { should have_content(editora.descricao) }
          it { should have_content(editora.cidade) }
          it { should have_content(editora.ano) }
          it { should have_title(editora.descricao) }
          it { should have_selector('div.alert.alert-success', text: 'sucessfully created') }
        end
      end
    end
  end

  describe "editar editora" do
    describe "deve estar logado" do
      let(:editora) { FactoryGirl.create(:editora) }
      before { visit edit_editora_path(:editora)  }

      it { should have_content('Please sign in.') }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:editora) { FactoryGirl.create(:editora) }

      before(:each) do
        sign_in usuario
        visit edit_editora_path(editora) 
      end

      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:editora) { FactoryGirl.create(:editora) }
      
      before do
        sign_in usuario
        visit edit_editora_path(editora)
      end
      it { should have_content('Edit editora') }
      it { should have_title('Edit editora') }
      it { should have_link("Cancel", href: editoras_path) }

      describe "com informacoes invalidas" do
        before do 
          fill_in "Descricao",             with: ""
          fill_in "Cidade",                with: ""
          fill_in "Ano",                   with: ""
          click_button "Save changes" 
        end

        it { should have_content("error") }
      end

      describe "com informacao vaidas" do
        let(:new_editora)  { "Novo editora" }
        let(:new_cidade)  { "Quixada" }
        let(:new_ano)  { "1980" }
        before do
          fill_in "Descricao",             with: new_editora
          fill_in "Cidade",                with: new_cidade
          fill_in "Ano",                   with: new_ano
          click_button "Save changes"
        end

        it { should have_title(new_editora) }
        it { should have_content(new_editora) }
        it { should have_content(new_cidade) }
        it { should have_content(new_ano) }
        it { should have_selector('div.alert.alert-success') }
        #it { should have_link('Sign out', href: signout_path) }
        specify { expect(editora.reload.descricao).to  eq new_editora }
        specify { expect(editora.reload.cidade).to  eq new_cidade }
        specify { expect(editora.reload.ano).to  eq new_ano }
      end
    end

  end


end
