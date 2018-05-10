FactoryBot.define do
  factory :session do
    token { SecureRandom.urlsafe_base64 }
    chat
  end
end