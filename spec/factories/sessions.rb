FactoryBot.define do
  factory :session do
    token { SecureRandom.uuid }
    chat
  end
end
