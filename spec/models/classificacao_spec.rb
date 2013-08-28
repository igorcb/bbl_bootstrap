require 'spec_helper'

describe Classificacao do
  before { @classificacao = Classificacao.new(cdd: "000.00", descricao: "classificacao exemplo") }

  subject { @classificacao }

  it { should respond_to(:cdd) }
  it { should respond_to(:descricao) }

  it { should be_valid }

  describe "quando a descricao nao estiver presente" do
    before { @classificacao.descricao = " " }
    it { should_not be_valid }
  end

  describe "quando o cdd é muito longo" do
    before { @classificacao.cdd = "a" * 11 }
    it { should_not be_valid }
  end

  describe "quando o descricao é muito longo" do
    before { @classificacao.descricao = "a" * 101 }
    it { should_not be_valid }
  end
end
