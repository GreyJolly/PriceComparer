# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    username { "testuser" }
    isAnalyst { false }
    isAdministrator { false }
    encrypted_password { "test" }
  end
end
