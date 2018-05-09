FactoryBot.define do
  factory :chat do
    token { SecureRandom.urlsafe_base64 }
    filled false
  end
end