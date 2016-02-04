require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'is_obstructed?' do
    it 'should return false for no horizontal obstructions moving to the right' do
      piece = FactoryGirl.create(:piece, row: 0, column: 3)

      expect(piece.is_obstructed?(0, 5)).to eq(false)
    end

    it 'should return false for no horizontal obstructions moving to the left' do
      piece = FactoryGirl.create(:piece, row: 0, column: 3)

      expect(piece.is_obstructed?(0, 1)).to eq(false)
    end

    it 'should return true for horizontal obstructions moving to the right' do
      piece1 = FactoryGirl.create(:piece, row: 0, column: 3)
      FactoryGirl.create(:piece, row: 0, column: 4, game: piece1.game)

      expect(piece1.is_obstructed?(0, 5)).to eq(true)
    end

    it 'should return true for horizontal obstructions moving to the left' do
      piece1 = FactoryGirl.create(:piece, row: 0, column: 3)
      FactoryGirl.create(:piece, row: 0, column: 2, game: piece1.game)

      expect(piece1.is_obstructed?(0, 1)).to eq(true)
    end

    it 'should return false for no vertical obstructions moving up' do
      piece = FactoryGirl.create(:piece, row: 3, column: 5)

      expect(piece.is_obstructed?(6, 5)).to eq(false)
    end

    it 'should return false for no vertical obstructions moving down' do
      piece = FactoryGirl.create(:piece, row: 3, column: 5)

      expect(piece.is_obstructed?(0, 5)).to eq(false)
    end

    it 'should return true for vertical obstructions moving up' do
      piece1 = FactoryGirl.create(:piece, row: 3, column: 5)
      FactoryGirl.create(:piece, row: 4, column: 5, game: piece1.game)

      expect(piece1.is_obstructed?(6, 5)).to eq(true)
    end

    it 'should return true for vertical obstructions moving down' do
      piece1 = FactoryGirl.create(:piece, row: 3, column: 5)
      FactoryGirl.create(:piece, row: 1, column: 5, game: piece1.game)

      expect(piece1.is_obstructed?(0, 5)).to eq(true)
    end

    it 'should return false for no diagonal obstructions moving up and to the right' do
      piece = FactoryGirl.create(:piece, row: 2, column: 2)
      expect(piece.is_obstructed?(4, 4)).to eq(false)
    end

    it 'should return false for no diagonal obstructions moving up and to the left' do
      piece = FactoryGirl.create(:piece, row: 2, column: 2)
      expect(piece.is_obstructed?(4, 0)).to eq(false)
    end

    it 'should return false for no diagonal obstructions moving down and to the right' do
      piece = FactoryGirl.create(:piece, row: 2, column: 2)
      expect(piece.is_obstructed?(0, 4)).to eq(false)
    end

    it 'should return false for no diagonal obstructions moving down and to the left' do
      piece = FactoryGirl.create(:piece, row: 2, column: 2)
      expect(piece.is_obstructed?(0, 0)).to eq(false)
    end

    it 'should return true for diagonal obstructions moving up and to the right' do
      piece1 = FactoryGirl.create(:piece, row: 2, column: 2)
      FactoryGirl.create(:piece, row: 3, column: 3, game: piece1.game)

      expect(piece1.is_obstructed?(4, 4)).to eq(true)
    end

    it 'should return true for diagonal obstructions moving up and to the left' do
      piece1 = FactoryGirl.create(:piece, row: 2, column: 2)
      FactoryGirl.create(:piece, row: 3, column: 1, game: piece1.game)

      expect(piece1.is_obstructed?(4, 0)).to eq(true)
    end

    it 'should return true for diagonal obstructions moving down and to the right' do
      piece1 = FactoryGirl.create(:piece, row: 2, column: 2)
      FactoryGirl.create(:piece, row: 1, column: 3, game: piece1.game)

      expect(piece1.is_obstructed?(0, 4)).to eq(true)
    end

    it 'should return true for diagonal obstructions moving down and to the left' do
      piece1 = FactoryGirl.create(:piece, row: 2, column: 2)
      FactoryGirl.create(:piece, row: 1, column: 1, game: piece1.game)

      expect(piece1.is_obstructed?(0, 0)).to eq(true)
    end

    it 'should return false when there is a piece at the destination and none in between' do
      piece1 = FactoryGirl.create(:piece, row: 0, column: 3)
      FactoryGirl.create(:piece, row: 0, column: 5, game: piece1.game)

      expect(piece1.is_obstructed?(0, 5)).to eq(false)
    end

    it "should return false if piece doesn't move" do
      piece = FactoryGirl.create(:piece, row: 0, column: 3)

      expect(piece.is_obstructed?(0, 3)).to eq(false)
    end

    it 'should raise an error message if input is invalid' do
      piece = FactoryGirl.create(:piece, row: 0, column: 3)

      expect { piece.is_obstructed?(2, 4) }.to raise_error('Input is invalid!')
    end
  end
end