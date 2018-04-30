class Chat < ApplicationRecord
  has_many :sessions
  has_many :messages, through: :sessions
end
