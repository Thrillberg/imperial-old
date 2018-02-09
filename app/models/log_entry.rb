class LogEntry < ApplicationRecord
  belongs_to :game
  belongs_to :country
end
