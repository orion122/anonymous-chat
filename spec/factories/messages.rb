FactoryBot.define do
  factory :message do
    message 'some text'
    state 'accepted'
    session
  end
end