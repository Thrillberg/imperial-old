require "rails_helper"

describe Player do
  it { should belong_to :pre_game }
  it { should belong_to :user }
  it { should have_many :countries }
end
