require "rails_helper"

describe Government do
  it { should belong_to :game }
  it { should belong_to :user }
  it { should have_many :countries }
end
