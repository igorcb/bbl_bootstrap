require 'spec_helper'

describe Autor do
  before { @autor = Autor.new(descricao: "Autor exemplo", cutter: "11.01")}

  subject { @autor }

  it { should respond_to(:descricao) }
  it { should respond_to(:cutter) }

  it { should be_valid }


  describe "quando a descricao nao estiver presente" do
    before { @autor.descricao = " " }
    it { should_not be_valid }
  end

  describe "quando a cutter nao estiver presente" do
    before { @autor.cutter = " " }
    it { should_not be_valid }
  end

  describe "quando o descricao é muito longo" do
    before { @autor.descricao = "a" * 101 }
    it { should_not be_valid }
  end

  describe "quando o cutter é muito longo" do
    before { @autor.cutter = "a" * 11 }
    it { should_not be_valid }
  end

end
