class Chat < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :messages, through: :sessions
end
