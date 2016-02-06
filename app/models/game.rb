class Game < ActiveRecord::Base
  has_many :pieces
  has_one  :white_player, class_name: 'User'
  has_one  :black_player, class_name: 'User'
  
  after_create :populate_board!
  
  def populate_board!

    
    order_of_back_row = ["Rook", "Knight", "Bishop", "King", "Queen", "Bishop", "Knight", "Rook"]
    order_of_back_row.each_with_index do |type, column|
      Piece.create(:type => type,  :color => "black", :row => 0, :column => column )
      Piece.create(:type => type,  :color => "white", :row => 7, :column => column )
      
      Piece.create(:type => "Pawn", :color => "black", :row => 1, :column => column )
      Piece.create(:type => "Pawn", :color => "white", :row => 6, :column => column )      
    end
  end
  
  
    
end
