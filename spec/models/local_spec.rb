require 'spec_helper'

describe Local do
  before { @local = Local.new(descricao: "local exemplo")}

  subject { @local }

  it { should respond_to(:descricao) }

  it { should be_valid }

  describe "quando a descricao nao estiver presente" do
    before { @local.descricao = " " }
    it { should_not be_valid }
  end

  describe "quando o descricao é muito longo" do
    before { @local.descricao = "a" * 101 }
    it { should_not be_valid }
  end
end
