class Message < ApplicationRecord
  belongs_to :session

  include AASM

  aasm column: 'state' do
    state :initial, initial: true
    state :accepted              # принято    (сервером)
    state :delivered             # доставлено (собеседнику)
    state :read                  # прочитано  (собеседником)

    event :accept do             # принять    (сервером)
      transitions from: :initial, to: :accepted
    end

    event :deliver do            # доставить  (собеседнику)
      transitions from: :accepted, to: :delivered
    end

    event :read do               # прочитать  (собеседником)
      transitions from: :delivered, to: :read
    end
  end
end
