class Game < ActiveRecord::Base
  has_many :pieces
  has_one  :white_player, class_name: 'User'
  has_one  :black_player, class_name: 'User'

  after_create :populate_board!

  def populate_board!
    order_of_back_row = %w(Rook Knight Bishop Queen King Bishop Knight Rook)
    order_of_back_row.each_with_index do |type, column|
      Piece.create(type: type, game: self, color: 'black', row: 0, column: column)
      Piece.create(type: type, game: self, color: 'white', row: 7, column: column)

      Piece.create(type: 'Pawn', game: self, color: 'black', row: 1, column: column)
      Piece.create(type: 'Pawn', game: self, color: 'white', row: 6, column: column)
    end
  end

  def stalemate?

  end

  def check?
    white_king = pieces.find_by(type: 'King', color: 'white')
    black_king = pieces.find_by(type: 'King', color: 'black')

    white_king.in_check? || black_king.in_check?
  end
end
