class Message < ApplicationRecord
  belongs_to :session

  include AASM

  aasm column: 'state' do
    state :initial, initial: true
    state :accepted
    state :delivered
    state :read

    event :accept do
      transitions from: :initial, to: :accepted
    end

    event :deliver do
      transitions from: :accepted, to: :delivered
    end

    event :read do
      transitions from: :delivered, to: :read
    end
  end
end
