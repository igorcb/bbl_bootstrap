require 'spec_helper'

describe Casa do
  before { @casa = Casa.new(descricao: "casa exemplo")}

  subject { @casa }

  it { should respond_to(:descricao) }

  it { should be_valid }

  describe "quando a descricao nao estiver presente" do
    before { @casa.descricao = " " }
    it { should_not be_valid }
  end

  describe "quando o descricao é muito longo" do
    before { @casa.descricao = "a" * 51 }
    it { should_not be_valid }
  end

end
