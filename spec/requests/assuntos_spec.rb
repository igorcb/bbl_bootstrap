require 'spec_helper'

describe "Assuntos pagina" do
  subject { page }

  describe "index" do
  	#let(:usuario) { FactoryGirl.create(:usuario) }
    let(:usuario) { FactoryGirl.create(:admin) }

  	before(:each) do
  		sign_in usuario
  	  visit assuntos_path
    end

  	it { should have_title('Assuntos') }
    it { should have_content('Listagem de assuntos') }
    it { should have_link('Novo Assunto') }

    describe "paginations" do
      before(:all) { 35.times { FactoryGirl.create(:assunto) } } 
      after(:all)  { Assunto.delete_all}

      it { should have_selector('div.pagination') }

      it "deve listar cada assunto" do
       Assunto.paginate(page: 1).each do |assunto|
         expect(page).to have_selector('td', text: assunto.descricao)
       end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "como um usuario administrador" do
        before { Assunto.create(descricao: "Exemplo teste") }

        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          sign_in admin
       	  visit assuntos_path
        end
      
        it { should have_link('Delete', href: assunto_path(Assunto.first)) }

        it "deve ser capaz de apagar assunto" do
          expect do
            click_link('Delete', match: :first)
          end.to change(Assunto, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end
    end

    describe "edit links" do
      before { @assunto = Assunto.create(descricao: "Exemplo teste") }
      after(:all)  { Assunto.delete_all}

      let(:admin) { FactoryGirl.create(:admin) }
      
      before do
        sign_in admin
     	  visit assuntos_path
      end
    
      it { should have_link('Editar', href: edit_assunto_path(@assunto)) }
    end
  end

  describe "show page" do
    let(:usuario) { FactoryGirl.create(:admin) }
    let(:assunto) { FactoryGirl.create(:assunto) }
    
    before do
      sign_in usuario
      visit assunto_path(assunto) 
    end

    it { should have_content(assunto.descricao) }
    it { should have_title(assunto.descricao) }
  end

  describe "novo assunto" do
    let(:usuario) { FactoryGirl.create(:admin) }

    before do
      sign_in usuario
      visit new_assunto_path 
    end
    it { should have_link("Cancelar", href: assuntos_path) }

    let(:submit) { "Salvar" }

    describe "com informacoes invalidas" do
      it "nao deve criar um assunto" do
        expect { click_button submit }.not_to change(Assunto, :count)
      end
    end
    
    describe "com informacoes validas" do
    	let(:nova_descricao) { 'Assunto exemplo' }
      before do
        fill_in "Descricao",         with: nova_descricao
      end

      it "deve criar um assunto" do
        expect { click_button submit }.to change(Assunto, :count).by(1)
      end

      describe "depois de salvar o usuario" do
        before { click_button submit }
        let(:assunto) { Assunto.find_by(descricao: nova_descricao) }

        #it { should have_link('Sign out') }
        it { should have_title(assunto.descricao) }
        it { should have_selector('div.alert.alert-success', text: 'sucessfully created') }
      end
    end
  end

  describe "editar" do
    let(:usuario) { FactoryGirl.create(:admin) }
    let(:assunto) { FactoryGirl.create(:assunto) }
    
    before do
      sign_in usuario
      visit edit_assunto_path(assunto)
    end

    it { should have_link("Cancelar", href: assuntos_path) }

    describe "pagina" do
      it { should have_content('Editar assunto') }
      it { should have_title('Editar assunto') }
      #it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

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
      it { should have_selector('div.alert.alert-success') }
      #it { should have_link('Sign out', href: signout_path) }
      specify { expect(assunto.reload.descricao).to  eq new_name }
    end
    
    # describe "forbidden attributes" do
    #   let(:params) do
    #     { assunto: { admin: true, password: usuario.password,
    #               password_confirmation: usuario.password } }
    #   end
    #   before { patch usuario_path(usuario), params }
    #   specify { expect(usuario.reload).not_to be_admin }
    # end
 
  end
end
