FactoryBot.define do
  factory :chat do
    token { SecureRandom.uuid }
    filled false
  end
end
