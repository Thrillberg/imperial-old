require "rails_helper"

describe Country do
  before do
    Game.create
  end

  it { should have_many :armies }
  it { should have_many :regions }
  it { should belong_to :player }
end