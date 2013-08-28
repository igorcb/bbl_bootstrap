require 'spec_helper'

describe Editora do
  before { @editora = Editora.new(descricao: "editora exemplo", cidade: "cidade exemplo", ano: "1900") }

  subject { @editora }

  it { should respond_to(:descricao) }
  it { should respond_to(:cidade) }
  it { should respond_to(:ano) }

  it { should be_valid }

  describe "quando a descricao nao estiver presente" do
    before { @editora.descricao = " " }
    it { should_not be_valid }
  end

  describe "quando o descricao é muito longo" do
    before { @editora.descricao = "a" * 101 }
    it { should_not be_valid }
  end

  describe "quando o cidade é muito longo" do
    before { @editora.cidade = "a" * 31 }
    it { should_not be_valid }
  end

  describe "quando o ano é muito longo" do
    before { @editora.ano = "a" * 5 }
    it { should_not be_valid }
  end

end
