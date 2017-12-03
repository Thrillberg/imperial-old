class CountryInvestor < ApplicationRecord
  belongs_to :country
  belongs_to :investor
end
