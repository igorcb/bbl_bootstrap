require 'spec_helper'

describe Assunto do
  before { @assunto = Assunto.new(descricao: "Assunto Exemplo") }

  subject { @assunto }

  it { should respond_to(:descricao) }

  it { should be_valid }

  describe "quando a descricao nao estiver presente" do
    before { @assunto.descricao = " " }
    it { should_not be_valid }
  end

  describe "quando o descricao é muito longo" do
    before { @assunto.descricao = "a" * 101 }
    it { should_not be_valid }
  end

end
