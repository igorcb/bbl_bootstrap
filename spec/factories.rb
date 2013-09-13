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
    descricao "Assunto Exemplo"
  end

end