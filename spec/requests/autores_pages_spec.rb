require 'spec_helper'

describe "Autores Paginas" do
  subject { page }

  describe "index" do

    describe "deve estar logado" do
  	  before { visit autores_path }

  	  it { should have_content('Please sign in.') }

    end

    describe "como usuario comum " do
	  	let(:usuario) { FactoryGirl.create(:usuario) }
  	  before(:each) do
  	  	sign_in usuario
  	    visit autores_path 
  	  end

  	  it { should have_content('administradores') }
    end

    describe "como usuario administrador" do
   	  let(:usuario) { FactoryGirl.create(:admin) }

    	before(:each) do
    		sign_in usuario
  	    visit autores_path
      end

      it { should have_title('Autores') }
      it { should have_content('Listagem de autores') }
      it { should have_link('Novo autor') }

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
      
        it { should have_link('Delete', href: autor_path(Autor.first)) }

        it "deve ser capaz de apagar autor" do
          expect do
            click_link('Delete', match: :first)
          end.to change(Autor, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end
    
    end


  end
end
