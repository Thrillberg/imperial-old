require "rails_helper"

describe Game do
  it { should have_one :board }
  it { should have_many :players }
  it { should have_many :countries }


  describe '#add_board' do
    it 'creates a board' do
      Game.create
      expect(Board.count).to eq(1)
    end
  end

  describe '#set_board_spaces' do
    it 'creates six countries' do
      Game.create
      expect(Country.count).to eq(6)
    end
  end
end
