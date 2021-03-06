FactoryGirl.define do
  factory :white_rook, parent: :piece, class: 'Rook' do
    row 0
    column 0
    color 'white'
    in_game true
    association :user
    association :game
  end

  factory :black_rook, parent: :piece, class: 'Rook' do
    row 0
    column 7
    in_game true
    color 'black'
    association :user
    association :game
  end
end
