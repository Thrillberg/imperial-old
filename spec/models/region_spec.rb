require "rails_helper"

describe Region do
  it { should have_many :pieces }
  it { should belong_to :game }
  it { should belong_to :country }

  it { should have_db_column(:land).of_type(:boolean).with_options(default: true) }
end
