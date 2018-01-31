require 'rails_helper'

RSpec.describe Rondel do
  subject(:rondel) { described_class.new current_action: current_action }

  let(:current_action) { :maneuver_1 }

  describe '.new' do
    context 'when given a misspelled action' do
      it do
        expect {
          described_class.new current_action: :manuever_1
        }.to raise_error(/not exist/)
      end
    end
  end

  describe '#current' do
    subject { rondel.current }

    it { is_expected.to eql current_action }
  end

  describe '#next' do
    subject { rondel.next count }

    context 'when advancing by one' do
      let(:count) { 1 }

      it do
        is_expected.to eql ok: {
          cost: 0,
          current_action: :taxation,
          passed: []
        }
      end
    end

    context 'when advancing by two' do
      let(:count) { 2 }

      it do
        is_expected.to eql ok: {
          cost: 0,
          current_action: :factory,
          passed: %i[taxation]
        }
      end
    end

    context 'when advancing by three' do
      let(:count) { 3 }

      it do
        is_expected.to eql ok: {
          cost: 0,
          current_action: :production_1,
          passed: %i[taxation factory]
        }
      end
    end

    context 'when advancing by four' do
      let(:count) { 4 }

      it do
        is_expected.to eql ok: {
          cost: 1,
          current_action: :maneuver_2,
          passed: %i[taxation factory production_1]
        }
      end
    end

    context 'when advancing by five' do
      let(:count) { 5 }

      it do
        is_expected.to eql ok: {
          cost: 2,
          current_action: :investor,
          passed: %i[taxation factory production_1 maneuver_2]
        }
      end
    end

    context' when advancing by six' do
      let(:count) { 6 }

      it do
        is_expected.to eql ok: {
          cost: 3,
          current_action: :import,
          passed: %i[taxation factory production_1 maneuver_2 investor]
        }
      end
    end

    context 'when advancing by seven' do
      let(:count) { 7 }

      it do
        is_expected.to eql err: {
          reason: "Can only advance up to 6 actions (tried 7)"
        }
      end
    end

    context 'when advancing by eight' do
      let(:count) { 8 }

      it do
        is_expected.to eql err: {
          reason: "Can only advance up to 6 actions (tried 8)"
        }
      end
    end
  end

  describe '#available' do
    subject { rondel.available }

    context 'when the current action is maneuver_1' do
      let(:current_action) { :maneuver_1 }

      it do
        is_expected.to eql [
          { id: :taxation, label: 'Taxation', cost: 0 },
          { id: :factory, label: 'Factory', cost: 0 },
          { id: :production_1, label: 'Production', cost: 0 },
          { id: :maneuver_2, label: 'Maneuver', cost: 1 },
          { id: :investor, label: 'Investor', cost: 2 },
          { id: :import, label: 'Import', cost: 3 }
        ]
      end

    end

    context 'when the current action is investor' do
      let(:current_action) { :investor }

      it do
        is_expected.to eql [
          { id: :import, label: 'Import', cost: 0 },
          { id: :production_2, label: 'Production', cost: 0 },
          { id: :maneuver_1, label: 'Maneuver', cost: 0 },
          { id: :taxation, label: 'Taxation', cost: 1 },
          { id: :factory, label: 'Factory', cost: 2 },
          { id: :production_1, label: 'Production', cost: 3 }
        ]
      end
    end
  end
end
