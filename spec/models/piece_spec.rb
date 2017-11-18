require "rails_helper"

describe Piece do
  it { should have_db_column(:passive).of_type(:boolean).with_options(default: false) }
  it { should belong_to :country }
  it { should belong_to :region }
end
