class Message < ApplicationRecord
  belongs_to :session

  include AASM

  aasm column: 'state' do
    state :unsent, initial: true # неотправленно
    state :forwarded             # отправлено (на сервер)
    state :accepted              # принято    (сервером)
    state :delivered             # доставлено (собеседнику)
    state :read                  # прочитано  (собеседником)

    event :forward do            # отправить  (на сервер)
      transitions from: [:unsent], to: :forwarded
    end

    event :accept do             # принять    (сервером)
      transitions from: [:forwarded], to: :accepted
    end

    event :deliver do            # доставить  (собеседнику)
      transitions from: [:accepted], to: :delivered
    end

    event :read do               # прочитать  (собеседником)
      transitions from: [:delivered], to: :read
    end
  end
end
