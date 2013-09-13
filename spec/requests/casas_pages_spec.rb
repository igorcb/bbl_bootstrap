require 'spec_helper'

describe "Casas pagina" do
  subject { page }

  describe "index" do
    describe "deve estar logado" do
      before { visit casas_path }

      it { should have_content("Please sign in.") }
    end

    describe "como um usuario comum" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before(:each) do
        sign_in usuario
        visit casas_path
      end
 
      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
  	  let(:usuario) { FactoryGirl.create(:admin) }
     	
     	before(:each) do
    	  sign_in usuario
    	  visit casas_path
      end
    	it { should have_title('Casas') }
      it { should have_content('All casas') }
      it { should have_link('New casa') }

      describe "paginations" do
        before(:all) { 35.times { FactoryGirl.create(:casa) } } 
        after(:all)  { Casa.delete_all}

        it { should have_selector('div.pagination') }

        it "deve listar cada casa" do
         Casa.paginate(page: 1).each do |casa|
           expect(page).to have_selector('td', text: casa.descricao)
         end
        end
      end

      describe "delete links" do
        it { should_not have_link('delete') }

        before { Casa.create(descricao: "Exemplo teste") }

        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          sign_in admin
          visit casas_path
        end
      
        it { should have_link('Delete', href: casa_path(Casa.first)) }

        it "deve ser capaz de apagar a casa" do
          expect do
            click_link('Delete', match: :first)
          end.to change(Casa, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end

      describe "edit links" do
        before { @casa = Casa.create(descricao: "Exemplo teste") }
        after(:all)  { Casa.delete_all}

        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          sign_in admin
          visit casas_path
        end
      
        it { should have_link('Edit', href: edit_casa_path(@casa)) }
      end
    end
  end

  describe "show page" do

    describe "deve estar logado" do
    let(:casa) { FactoryGirl.create(:casa) }
      before { visit casas_path(casa) }

      it { should have_content("Please sign in.") }
    end

    describe "como um usuario comum" do
      let(:casa) { FactoryGirl.create(:casa) }
      let(:usuario) { FactoryGirl.create(:usuario) }
      before(:each) do
        sign_in usuario
        visit casas_path(casa)
      end
 
      it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:casa) { FactoryGirl.create(:casa) }
      
      before do
        sign_in usuario
        visit casa_path(casa) 
      end

      it { should have_content(casa.descricao) }
      it { should have_title(casa.descricao) }
    end
  end

  describe "nova casa" do
    describe "deve estar logado" do

      before { visit new_casa_path }

      it { should have_content("Please sign in.") }
    end

    describe "como um usuario comum" do
      let(:usuario) { FactoryGirl.create(:usuario) }
  
      before(:each) do
        sign_in usuario
        visit new_casa_path
      end
 
      it { should have_content('administradores') }
    end
  
    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }

      before do
        sign_in usuario
        visit new_casa_path 
      end
      it { should have_content("New casa") }
      it { should have_title("New casa") }
      it { should have_link("Cancel", href: casas_path) }

      let(:submit) { "Save casa" }

      describe "com informacoes invalidas" do
        it "nao deve criar uma casa" do
          expect { click_button submit }.not_to change(Casa, :count)
        end
      end
      
      describe "com informacoes validas" do
        let(:nova_descricao) { 'Casa exemplo' }
        before do
          fill_in "Descricao",         with: nova_descricao
        end

        it "deve criar um casa" do
          expect { click_button submit }.to change(Casa, :count).by(1)
        end

        describe "depois de salvar a casa" do
          before { click_button submit }
          let(:casa) { Casa.find_by(descricao: nova_descricao) }

          #it { should have_link('Sign out') }
          it { should have_title(casa.descricao) }
          it { should have_selector('div.alert.alert-success', text: 'sucessfully created') }
        end
      end
    end
  end

  describe "editar" do
    describe "deve estar logado" do
      let(:casa) { FactoryGirl.create(:casa) }
      before { visit edit_casa_path(casa) }

      it { should have_content("Please sign in.") }
    end

    describe "como um usuario comum" do
      let(:casa) { FactoryGirl.create(:casa) }
      let(:usuario) { FactoryGirl.create(:usuario) }
  
      before(:each) do
        sign_in usuario
        visit edit_casa_path(casa)
      end
 
      it { should have_content('administradores') }
    end
  
    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:casa) { FactoryGirl.create(:casa) }
      
      before do
        sign_in usuario
        visit edit_casa_path(casa)
      end

      it { should have_content('Edit casa') }
      it { should have_title('Edit casa') }
      it { should have_link("Cancel", href: casas_path) }

      describe "com informacoes invalidas" do
        before do 
          fill_in "Descricao",             with: ""
          click_button "Save changes" 
        end

        it { should have_content("error") }
      end

      describe "com informacao vaidas" do
        let(:new_name)  { "New Name" }
        before do
          fill_in "Descricao",             with: new_name
          click_button "Save changes"
        end

        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success', text: 'sucessfully update') }
        #it { should have_link('Sign out', href: signout_path) }
        specify { expect(casa.reload.descricao).to  eq new_name }
      end
    end

  end

end
