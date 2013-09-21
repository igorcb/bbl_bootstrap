require 'spec_helper'

describe "Livros Pagina" do
  subject { page }

  describe "index" do
    describe "deve estar logado" do
      before { visit livros_path }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before(:each) do
        sign_in usuario
        visit livros_path 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
 
      before(:each) do
        sign_in usuario
        visit livros_path
      end

      it { should have_title('Livros') }
      it { should have_content(I18n.t('views.listing') + ' livros') }
      it { should have_link(I18n.t('views.new') + ' livro', href: new_livro_path) }

      describe "paginations" do
        before(:all) { 35.times { FactoryGirl.create(:livro) } }
        after(:all)  do
          Livro.delete_all
          Casa.delete_all
          Autor.delete_all
          Editora.delete_all
          Local.delete_all
          Assunto.delete_all
          Classificacao.delete_all
        end

        it { should have_selector('div.pagination') }

        it { should have_selector('th', text: "Tombo") }
        it { should have_selector('th', text: "Cutter") }
        it { should have_selector('th', text: "Título") }
        it { should have_selector('th', text: "Casa") }
        it { should have_selector('th', text: "Autor") }
        it { should have_selector('th', text: "Assunto") }
        it { should have_selector('th', text: "Classificação") }

        it "deve listar cada livro" do
         Livro.paginate(page: 1).each do |livro|
           expect(page).to have_selector('td', text: livro.num_tombo)
           expect(page).to have_selector('td', text: livro.cutter)
           expect(page).to have_selector('td', text: livro.descricao)
           expect(page).to have_selector('td', text: livro.casa.descricao)
           expect(page).to have_selector('td', text: livro.autor.descricao)
           expect(page).to have_selector('td', text: livro.assunto.descricao)
           expect(page).to have_selector('td', text: livro.classificacao.cdd)
         end
        end
      end

      describe "delete links" do
        before { FactoryGirl.create(:livro) }
        after(:all)  do
          Livro.delete_all
          Casa.delete_all
          Autor.delete_all
          Editora.delete_all
          Local.delete_all
          Assunto.delete_all
          Classificacao.delete_all
        end

        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          sign_in admin
          visit livros_path
        end
      
        it { should have_link(I18n.t('views.destroy'), href: livro_path(Livro.first)) }

        it "deve ser capaz de apagar livro" do
          expect do
            click_link(I18n.t('views.destroy'), match: :first)
          end.to change(Livro, :count).by(-1)
        end
        # it { should_not have_link('delete', href: usuario_path(admin)) }
      end

      describe "edit links" do
        before { @livro = FactoryGirl.create(:livro) }
        after(:all)  do
          Livro.delete_all
          Casa.delete_all
          Autor.delete_all
          Editora.delete_all
          Local.delete_all
          Assunto.delete_all
          Classificacao.delete_all
        end

        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          sign_in admin
          visit livros_path
        end
      
        it { should have_link(I18n.t('views.edit'), href: edit_livro_path(@livro)) }
      end

    end
  end

  describe "show page" do
    describe "deve estar logado" do
      let(:livro) { FactoryGirl.create(:livro) }
      before { visit livro_path(livro) }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:livro) { FactoryGirl.create(:livro) }

      before(:each) do
        sign_in usuario
        visit livro_path(livro) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:livro) { FactoryGirl.create(:livro) }
      
      before do
        sign_in usuario
        visit livro_path(livro) 
      end

      it { should have_selector('h1', text: 'Título:') }
      it { should have_selector('strong', text: 'Nº Tombo:') }
      it { should have_selector('strong', text: 'Casa:') }
      it { should have_selector('strong', text: 'Autor:') }
      it { should have_selector('strong', text: 'Editora:') }
      it { should have_selector('strong', text: 'Local:') }
      it { should have_selector('strong', text: 'Assunto:') }
      it { should have_selector('strong', text: 'Classificação:') }
      it { should have_selector('strong', text: 'Cutter:') }
      it { should have_selector('strong', text: 'ISBN:') }
      it { should have_selector('strong', text: 'Edição:') }
      it { should have_selector('strong', text: 'Ano:') }
      it { should have_selector('strong', text: 'Páginas:') }
      it { should have_selector('strong', text: 'Localização:') }

      it { should have_title(livro.descricao) }
      it { should have_selector('h1', text: livro.descricao) }
      it { should have_content(livro.num_tombo) }
      it { should have_content(livro.casa.descricao) }
      it { should have_content(livro.autor.descricao) }
      it { should have_content(livro.editora.descricao) }
      it { should have_content(livro.local.descricao) }
      it { should have_content(livro.assunto.descricao) }
      it { should have_content(livro.classificacao.cdd) }
      it { should have_content(livro.isbn) }
      it { should have_content(livro.cutter) }
      it { should have_content(livro.edicao) }
      it { should have_content(livro.ano) }
      it { should have_content(livro.paginas) }
      it { should have_content(livro.localizacao) }

      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t('views.new'), href: new_livro_path) }
      it { should have_link(I18n.t('views.edit'), href: edit_livro_path(livro)) }
      it { should have_link(I18n.t('views.list'), href: livros_path) }
    end
  end

  describe "novo livro" do
    describe "deve estar logado" do
      let(:livro) { FactoryGirl.create(:livro) }
      before { visit new_livro_path }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:livro) { FactoryGirl.create(:livro) }

      before(:each) do
        sign_in usuario
        visit new_livro_path
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }

      before do
        sign_in usuario
        visit new_livro_path 
      end
      it { should have_title(I18n.t('views.new') + ' livro') }
      it { should have_content(I18n.t('views.new') + ' livro') }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t("views.cancel"), href: livros_path) }

      let(:submit) { I18n.t("views.save") }

      describe "com informacoes invalidas" do
        it "nao deve criar um livro" do
          expect { click_button submit }.not_to change(Livro, :count)
        end
      end

      describe "com informacoes validas" do
        before { @livro = FactoryGirl.create(:livro) }
        before(:all) do
          casas         = FactoryGirl.create_list(:casa, 10)
          autores       = FactoryGirl.create_list(:autor, 10)
          editora       = FactoryGirl.create_list(:editora, 10)
          locais        = FactoryGirl.create_list(:local, 10)
          assuntos      = FactoryGirl.create_list(:assunto, 10)
          classifcacoes = FactoryGirl.create_list(:classificacao, 10)
        end
        after(:all)  do
          Livro.delete_all
          Casa.delete_all
          Autor.delete_all
          Editora.delete_all
          Local.delete_all
          Assunto.delete_all
          Classificacao.delete_all
        end
        let(:novo_num_tombo)   { "000111" }
        let(:nova_descricao)   { 'Novo livro para exemplo' }
        let(:novo_cutter)      { "00.11" }
        let(:novo_isbn)        { "99000000011" }
        let(:nova_edicao)      { "1" }
        let(:novo_ano)         { "1995" }
        let(:nova_pagina)      { "500" }
        let(:nova_localizacao) { "EST 5 / PRTL 10" }
        let(:nova_casa)        { Casa.first }
        let(:novo_autor)       { Autor.first }
        let(:nova_editora)     { Editora.first }
        let(:novo_local)       { Local.first }
        let(:novo_assunto)     { Assunto.first }
        let(:nova_classificacao) { Classificacao.first }

        before do
          select(nova_casa.descricao,         from: 'livro_casa_id')
          select(novo_autor.descricao,        from: 'livro_autor_id')
          select(nova_editora.descricao,      from: 'livro_editora_id')
          select(novo_local.descricao,        from: 'livro_local_id')
          select(novo_assunto.descricao,      from: 'livro_assunto_id')
          select(nova_classificacao.descricao, from: 'livro_classificacao_id')

          fill_in "Nº Tombo",    with: novo_num_tombo
          fill_in "Descrição",   with: nova_descricao
          fill_in "Cutter",      with: novo_cutter
          fill_in "ISBN",        with: novo_isbn
          fill_in "Edição",      with: nova_edicao
          fill_in "Ano",         with: novo_ano
          fill_in "Páginas",     with: nova_pagina
          fill_in "Localização", with: nova_localizacao
        end

        it "deve criar um livro" do
          expect { 

            click_button submit 

            }.to change(Livro, :count).by(1)
        end

        describe "depois de salvar o livro" do
          before { click_button submit }
          let(:livro) { Livro.find_by(num_tombo: novo_num_tombo) }

        #   #it { should have_link('Sign out') }
          it { should have_title(livro.descricao) }
          it { should have_selector('h1', text: livro.descricao) }
          it { should have_content(livro.num_tombo) }
          it { should have_content(livro.casa.descricao) }
          it { should have_content(livro.autor.descricao) }
          it { should have_content(livro.editora.descricao) }
          it { should have_content(livro.local.descricao) }
          it { should have_content(livro.assunto.descricao) }
          it { should have_content(livro.classificacao.cdd) }
          it { should have_content(livro.isbn) }
          it { should have_content(livro.cutter) }
          it { should have_content(livro.edicao) }
          it { should have_content(livro.ano) }
          it { should have_content(livro.paginas) }
          it { should have_content(livro.localizacao) }
          it { should have_selector('div.alert.alert-success', text: 'sucessfully created') }
        end
      end
    end    
  end

  describe "editar" do
    describe "deve estar logado" do
      let(:livro) { FactoryGirl.create(:livro) }
      before { visit edit_livro_path(livro) }

      it { should have_content(I18n.t(:please_sign_in)) }
    end

    describe "como usuario comum " do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:livro) { FactoryGirl.create(:livro) }

      before(:each) do
        sign_in usuario
        visit edit_livro_path(livro) 
      end

      it { should have_content(I18n.t(:only_administrator)) }
    end

    describe "como usuario administrador" do
      let(:usuario) { FactoryGirl.create(:admin) }
      let(:livro) { FactoryGirl.create(:livro) }
      
      before do
        sign_in usuario
        visit edit_livro_path(livro)
      end
      it { should have_title(I18n.t('views.edit') + ' livro') }
      it { should have_content(I18n.t('views.edit') + ' livro') }
      it { should have_selector('div.form-actions') }
      it { should have_link(I18n.t("views.cancel"), href: livros_path) }

      describe "com informacoes invalidas" do
        before do 
          fill_in "Nº Tombo",    with: ""
          fill_in "Descrição",   with: ""
          fill_in "Cutter",      with: ""
          fill_in "ISBN",        with: ""

          click_button I18n.t("views.update")
        end
        it { should have_content("error") }
      end

      describe "com informacao validas" do
        #let(:novo_num_tombo)   { "000111" }
        let(:nova_descricao)   { 'Novo livro para exemplo edit' }
        let(:novo_cutter)      { "00.99" }
        let(:novo_isbn)        { "99000000099" }
        let(:nova_casa)        { Casa.last }
        let(:novo_autor)       { Autor.last }
        let(:nova_editora)     { Editora.last }
        let(:novo_local)       { Local.last }
        let(:novo_assunto)     { Assunto.last }
        let(:nova_classificacao) { Classificacao.last }
        # before { @livro = FactoryGirl.create(:livro) }

        before(:all) do
          casas         = FactoryGirl.create_list(:casa, 10)
          autores       = FactoryGirl.create_list(:autor, 10)
          editora       = FactoryGirl.create_list(:editora, 10)
          locais        = FactoryGirl.create_list(:local, 10)
          assuntos      = FactoryGirl.create_list(:assunto, 10)
          classifcacoes = FactoryGirl.create_list(:classificacao, 10)
        end
        after(:all)  do
          Livro.delete_all
          Casa.delete_all
          Autor.delete_all
          Editora.delete_all
          Local.delete_all
          Assunto.delete_all
          Classificacao.delete_all
        end

        before do
          select(nova_casa.descricao,         from: 'livro_casa_id')
          select(novo_autor.descricao,        from: 'livro_autor_id')
          select(nova_editora.descricao,      from: 'livro_editora_id')
          select(novo_local.descricao,        from: 'livro_local_id')
          select(novo_assunto.descricao,      from: 'livro_assunto_id')
          select(nova_classificacao.descricao, from: 'livro_classificacao_id')

          # fill_in "Nº Tombo",    with: novo_num_tombo
          fill_in "Descrição",   with: nova_descricao
          fill_in "Cutter",      with: novo_cutter
          fill_in "ISBN",        with: novo_isbn

          click_button I18n.t("views.update")
        end

        it { should have_title(nova_descricao) }
        it { should have_content(novo_cutter) }
        it { should have_content(novo_isbn) }
        it { should have_selector('div.alert.alert-success') }
        #it { should have_link('Sign out', href: signout_path) }
        specify { expect(livro.reload.descricao).to  eq nova_descricao }
        specify { expect(livro.reload.cutter).to  eq novo_cutter }
        specify { expect(livro.reload.isbn).to  eq novo_isbn }
      end
    
    end

  end  

end
