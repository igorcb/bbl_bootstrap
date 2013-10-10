require 'spec_helper'

describe Livro do
	let(:casa) { FactoryGirl.create(:casa) }
	let(:autor) { FactoryGirl.create(:autor) }
	let(:editora) { FactoryGirl.create(:editora) }
	let(:local) { FactoryGirl.create(:local) }
	let(:assunto) { FactoryGirl.create(:assunto) }
	let(:classificacao) { FactoryGirl.create(:classificacao) }

  before { @livro = Livro.new( casa_id: casa.id, 
  	                          autor_id: autor.id, 
  	                        editora_id: editora.id,
  	                          local_id: local.id,
  	                        assunto_id: assunto.id,
  	                  classificacao_id: classificacao.id,
  	                         #num_tombo: "000001",
  	                         descricao: "Livro Numero 00001",
  	                            cutter: "A001A",
  	                              isbn: "85-00-00000-1",
  	                            edicao: "1",
  	                               ano: "1990",
  	                           paginas: "300",
   	                       localizacao: "EST. 01 / PRAT 01"
   	                         ) }

  subject { @livro }

  it { should respond_to(:casa_id) }
  it { should respond_to(:autor_id) }
  it { should respond_to(:editora_id) }
  it { should respond_to(:local_id) }
  it { should respond_to(:assunto_id) }
  it { should respond_to(:classificacao_id) }
  it { should respond_to(:num_tombo) }
  it { should respond_to(:descricao) }
  it { should respond_to(:cutter) }
  it { should respond_to(:isbn) }
  it { should respond_to(:edicao) }
  it { should respond_to(:ano) }
  it { should respond_to(:paginas) }
  it { should respond_to(:localizacao) }

  it { should respond_to(:casa)}
  it { should respond_to(:autor)}
  it { should respond_to(:editora)}
  it { should respond_to(:local)}
  it { should respond_to(:assunto)}
  it { should respond_to(:classificacao)}

  it { should be_valid }


  describe "sugerir num_tombo  " do
    before { @livro.save }
    its(:num_tombo) { should_not be_blank }
  end  

  describe "quando a casa_id nao estiver presente" do
    before { @livro.casa_id = nil }
    it { should_not be_valid }
  end

  describe "quando a autor_id nao estiver presente" do
    before { @livro.autor_id = nil }
    it { should_not be_valid }
  end

  describe "quando a editora_id nao estiver presente" do
    before { @livro.editora_id = nil }
    it { should_not be_valid }
  end

  describe "quando a local_id nao estiver presente" do
    before { @livro.local_id = nil }
    it { should_not be_valid }
  end

  describe "quando a assunto_id nao estiver presente" do
    before { @livro.assunto_id = nil }
    it { should_not be_valid }
  end

  describe "quando a classificacao_id nao estiver presente" do
    before { @livro.classificacao_id = nil }
    it { should_not be_valid }
  end

  # describe "quando a num_tombo nao estiver presente" do
  #   before { @livro.num_tombo = " " }
  #   it { should_not be_valid }
  # end

  describe "quando a descricao nao estiver presente" do
    before { @livro.descricao = " " }
    it { should_not be_valid }
  end

  describe "quando a cutter nao estiver presente" do
    before { @livro.cutter = " " }
    it { should_not be_valid }
  end

  describe "quando o num_tombo é muito longo" do
    before { @livro.num_tombo = "a" * 11 }
    it { should_not be_valid }
  end

  describe "quando o descricao é muito longo" do
    before { @livro.descricao = "a" * 101 }
    it { should_not be_valid }
  end

  describe "quando o cutter é muito longo" do
    before { @livro.cutter = "a" * 26 }
    it { should_not be_valid }
  end

  describe "quando o isbn é muito longo" do
    before { @livro.isbn = "a" * 31 }
    it { should_not be_valid }
  end

  describe "quando a edicao é muito longo" do
    before { @livro.edicao = "a" * 11 }
    it { should_not be_valid }
  end

  describe "quando o ano é muito longo" do
    before { @livro.ano = "a" * 5 }
    it { should_not be_valid }
  end

  describe "quando a pagina é muito longo" do
    before { @livro.ano = "a" * 26 }
    it { should_not be_valid }
  end

  describe "quando a localizacao é muito longo" do
    before { @livro.localizacao = "a" * 26 }
    it { should_not be_valid }
  end

  describe "pega proximo tombo" do
  	before do
  		@livro.num_tombo = @livro.proxtombo 
  	end
  	it { @livro.num_tombo.to_s == '2' }
  end

end
