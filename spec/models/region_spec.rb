require "rails_helper"

describe Region do
  it { should have_db_column(:land).of_type(:boolean).with_options(default: true) }
  it { should have_many :pieces }
end
