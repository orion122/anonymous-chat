FactoryBot.define do
  factory :session do
    token { SecureRandom.uuid }
    nickname 'nickname'
    chat
  end
end
