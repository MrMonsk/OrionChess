require 'rails_helper'

RSpec.describe Pawn, type: :model do
  before do
    # Note: We want the board to be emptry for this test.
    allow_any_instance_of(Game).to receive(:populate_board!).and_return true
  end

  describe '#valid_move?' do
    it 'returns true when pawn moves to an empty space two spaces forward if it is the first move and unobstructed' do
      pawn = FactoryGirl.create(:black_pawn)

      expect(pawn.valid_move?(3, 4)).to eq(true)
    end

    it 'returns false when pawn moves to an empty space two spaces forward if it is the first move and the path is obstructed' do
      pawn = FactoryGirl.create(:black_pawn)
      FactoryGirl.create(:black_pawn, row: 2, column: 4, game: pawn.game)

      expect(pawn.valid_move?(3, 4)).to eq(false)
    end

    it 'returns false if trying to move two spaces forward and it is not the first move' do
      pawn = FactoryGirl.create(:white_pawn, row: 5)
      pawn.touch

      expect(pawn.valid_move?(3, 4)).to eq(false)
    end

    it 'returns true when pawn moves to empty space one space forward' do
      pawn = FactoryGirl.create(:black_pawn, row: 3)

      expect(pawn.valid_move?(4, 4)).to eq(true)
    end

    it 'returns false if pawn is trying to capture vertically' do
      pawn = FactoryGirl.create(:white_pawn)
      FactoryGirl.create(:piece, row: 4, column: 4, color: 'black', game: pawn.game)

      expect(pawn.valid_move?(4, 4)).to eq(false)
    end

    it 'returns false if pawn tries moving to a space occupied by a piece of the same color' do
      pawn = FactoryGirl.create(:black_pawn)
      FactoryGirl.create(:piece, row: 2, column: 4, color: 'black', game: pawn.game)

      expect(pawn.valid_move?(2, 4)).to eq(false)
    end

    it 'returns true when pawn moves diagonally one space forward to capture a piece' do
      pawn = FactoryGirl.create(:white_pawn)
      FactoryGirl.create(:piece, row: 5, column: 5, color: 'black', game: pawn.game)

      expect(pawn.valid_move?(5, 5)).to eq(true)
    end

    it 'returns false when pawn tries to move diagonally when not capturing another piece' do
      pawn = FactoryGirl.create(:black_pawn)

      expect(pawn.valid_move?(2, 5)).to eq(false)
    end

    it 'returns true for en passant move if opponent pawn moved two spaces for it\'s first move and was the last piece to move' do
      white_pawn = FactoryGirl.create(:white_pawn)
      black_pawn = FactoryGirl.create(:black_pawn, row: 4, column: 5, game: white_pawn.game)

      white_pawn.move_to!(4, 4)

      expect(black_pawn.valid_move?(5, 4)).to eq(true)
    end

    it 'returns false for en passant move if opponent did not move two for it\'s first move' do
      white_pawn = FactoryGirl.create(:white_pawn)
      black_pawn = FactoryGirl.create(:black_pawn, row: 4, column: 5, game: white_pawn.game)

      white_pawn.move_to!(5, 4)
      white_pawn.move_to!(4, 4)

      expect(black_pawn.valid_move?(5, 4)).to eq(false)
    end

    it 'returns false for en passant move if opponent pawn moved two spaces for it\'s first move but wasn\'t the last piece to move' do
      white_pawn = FactoryGirl.create(:white_pawn)
      black_pawn1 = FactoryGirl.create(:black_pawn, row: 4, column: 5, game: white_pawn.game)
      black_pawn2 = FactoryGirl.create(:black_pawn, game: white_pawn.game)

      white_pawn.move_to!(4, 4)
      black_pawn2.move_to!(2, 4)

      expect(black_pawn1.valid_move?(5, 4)).to eq(false)
    end

    it 'returns false for en passant move if opponent piece is not a pawn' do
      white_queen = FactoryGirl.create(:queen, row: 6, column: 4)
      black_pawn = FactoryGirl.create(:black_pawn, row: 4, column: 5, game: white_queen.game)

      white_queen.move_to!(4, 4)

      expect(black_pawn.valid_move?(5, 4)).to eq(false)
    end

    it 'always returns false when pawn tries moving horizontally' do
      pawn = FactoryGirl.create(:white_pawn)

      expect(pawn.valid_move?(6, 5)).to eq(false)
    end

    it 'always returns false when pawn tries moving backwards' do
      pawn = FactoryGirl.create(:black_pawn)

      expect(pawn.valid_move?(0, 4)).to eq(false)
    end

    it 'always returns false when trying to move forward more than two spaces' do
      pawn = FactoryGirl.create(:white_pawn)

      expect(pawn.valid_move?(2, 4)).to eq(false)
    end

    it 'always returns false when trying to move diagonally more than one space' do
      pawn = FactoryGirl.create(:black_pawn)

      expect(pawn.valid_move?(3, 6)).to eq(false)
    end
  end

  describe '#promote_pawn' do
    before do
      allow_any_instance_of(Game).to receive(:populate_board!).and_return true
    end

    let(:game) { FactoryGirl.create(:game) }
    let(:pawn) { FactoryGirl.create(:white_pawn, type: 'Pawn', row: 0, game: game) }

    it 'removes the pawn' do
      pawn.promote_pawn('Queen')

      pawn = game.pieces.find_by(type: 'Pawn')

      expect(pawn.in_game).to eq(false)
    end

    it 'adds a new queen when promoting to queen' do
      pawn.promote_pawn('Queen')

      expect(game.pieces.exists?(type: 'Queen')).to eq(true)
    end

    it 'adds a new knight when promoting to knight' do
      pawn.promote_pawn('Knight')

      expect(game.pieces.exists?(type: 'Knight')).to eq(true)
    end

    it 'adds a new rook when promoting to rook' do
      pawn.promote_pawn('Rook')

      expect(game.pieces.exists?(type: 'Rook')).to eq(true)
    end

    it 'adds a new bishop when promoting to bishop' do
      pawn.promote_pawn('Bishop')

      expect(game.pieces.exists?(type: 'Bishop')).to eq(true)
    end
  end
end
