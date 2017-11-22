require "rails_helper"

describe Player do
  it { should belong_to :game }
  it { should belong_to :user }
  it { should have_many :countries }
end
