require 'rails_helper'

feature 'Moving pieces', js: true do
  given(:user) { FactoryGirl.create(:user) }

  background do
    allow_any_instance_of(Game).to receive(:populate_board!).and_return true
    logged_as user
  end

  given(:game) { FactoryGirl.create(:game, black_player: user) }

  scenario 'Dragging a piece(black_pawn) to a valid location' do
    page.set_rack_session(user_id: game.black_player.id)
    game.pieces << FactoryGirl.create(:black_pawn, type: 'Pawn')
    visit game_path(game)
    black_pawn = page.find('.ui-draggable', text: 'o')
    destination = page.find('tr:nth-child(3) td:nth-child(5)')
    black_pawn.drag_to(destination)
    wait_for_ajax

    expect(page).to have_css('tr:nth-child(3) td:nth-child(5) span', text: 'o')
    expect(game.pieces.first.row).to eq(2)
  end

  scenario 'Dragging a piece(black_pawn) to an invalid location' do
    game.pieces << FactoryGirl.create(:black_pawn, type: 'Pawn')
    visit game_path(game)
    black_pawn = page.find('.ui-draggable', text: 'o')
    destination = page.find('tr:nth-child(3) td:nth-child(3)')
    black_pawn.drag_to(destination)
    wait_for_ajax

    expect(page).to have_css('tr:nth-child(2) td:nth-child(5) span', text: 'o')
    expect(game.pieces.first.row).to eq(1)
  end

  scenario 'Dragging a piece(black_pawn) to capture a piece(white_pawn) should remove the captured piece from the board and put it into the players captured pieces location' do
    game.pieces << FactoryGirl.create(:black_pawn, type: 'Pawn')
    game.pieces << FactoryGirl.create(:white_pawn, type: 'Pawn', row: 2, column: 3)
    visit game_path(game)
    black_pawn = page.find('.ui-draggable', text: 'o')
    destination = page.find('tr:nth-child(3) td:nth-child(4)')
    black_pawn.drag_to(destination)
    wait_for_ajax

    expect(page).not_to have_css('tr:nth-child(3) td:nth-child(4) span', text: 'p')
    expect(page).to have_css('#black-player-info .captured-pieces', text: 'p')
  end

  scenario 'Dragging pawn to opponent\'s back row to bring up pawn promotion modal' do
    game.pieces << FactoryGirl.create(:black_pawn, type: 'Pawn', row: 6)
    visit game_path(game)
    black_pawn = page.find('.ui-draggable', text: 'o')
    destination = page.find('tr:nth-child(8) td:nth-child(5)')
    black_pawn.drag_to(destination)
    wait_for_ajax

    expect(page).to have_content('Promote pawn to:')
  end

  scenario 'After submitting pawn promotion modal, should now show new piece type and no pawn' do
    game.pieces << FactoryGirl.create(:black_pawn, type: 'Pawn', row: 6)
    visit game_path(game)
    black_pawn = page.find('.ui-draggable', text: 'o')
    destination = page.find('tr:nth-child(8) td:nth-child(5)')
    black_pawn.drag_to(destination)
    wait_for_ajax
    within('#pawn-promotion') do
      find('.promotion', text: 'w').click
    end
    wait_for_ajax

    expect(page).to have_css('tr:nth-child(8) td:nth-child(5) span', text: 'w')
  end
end
