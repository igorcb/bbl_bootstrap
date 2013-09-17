FactoryGirl.define do
  factory :usuario do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :assunto do
    sequence(:descricao)  { |n| "Assunto #{n}" }
  end

  factory :autor do
  	#descricao "Autor exemplo"
  	#cutter "11.01"
    sequence(:descricao)  { |n| "Autor #{n}" }
    sequence(:cutter)     { |n| "11.#{n}" }
  end

  factory :casa do
    sequence(:descricao)  { |n| "Casa #{n}" }
  end

  factory :classificacao do
    # cdd "000.00" 
    # descricao "classificacao exemplo"
    sequence(:cdd)     { |n| "000.0#{n}" }
    sequence(:descricao)  { |n| "Classificacao #{n}" }
  end

  factory :editora do
    # descricao "editora exemplo"
    # cidade "cidade exemplo"
    # ano "1900"
    sequence(:descricao)  { |n| "Editora #{n}" }
    sequence(:cidade)     { |n| "Fortaleza" }
    sequence(:ano)        { |n| "1990" }
  end

  factory :local do
    sequence(:descricao)  { |n| "Local #{n}" }
  end

  factory :livro do
    association :casa,    factory: :casa
    association :autor,   factory: :autor
    association :editora, factory: :editora
    association :local,   factory: :local
    association :assunto, factory: :assunto
    association :classificacao, factory: :classificacao
    sequence(:num_tombo)    { |n| "000 #{n}" }
    sequence(:descricao)    { |n| "Livro para exemplo #{n}" }
    sequence(:cutter)       { |n| "00.#{n}" }
    sequence(:isbn)         { |n| "9900000000#{n}" }
    edicao      "1"
    ano         "1990"
    paginas     "300"
    localizacao "EST 5 / PRTL 10"

  end

end