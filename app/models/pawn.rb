class Pawn < Piece
  def chess_font_character
    if white?
      'p'
    else
      'o'
    end
  end
  
  def valid_move?
    
  end
end
