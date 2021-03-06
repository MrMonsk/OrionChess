FactoryGirl.define do
  factory :black_pawn, parent: :piece, class: 'Pawn' do
    row 1
    column 4
    in_game true
    color 'black'
    association :user
    association :game
  end

  factory :white_pawn, parent: :piece, class: 'Pawn' do
    row 6
    column 4
    in_game true
    color 'white'
    association :user
    association :game
  end
end
