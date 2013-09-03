FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :assunto do
    descricao "Assunto Exemplo"
  end

  factory :autor do
  	descricao "Autor exemplo"
  	cutter "11.01"
  end

  factory :casa do
    descricao "Casa Exemplo"
  end

  factory :classificacao do
    cdd "000.00" 
    descricao "classificacao exemplo"
  end

  factory :editora do
    descricao "editora exemplo"
    cidade "cidade exemplo"
    ano "1900"
  end

  factory :local do
    descricao "Assunto Exemplo"
  end

end