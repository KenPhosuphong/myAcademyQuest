require 'rails_helper'

RSpec.describe "Quests", type: :system do
  before do
    # rack_test cannot handle Turbo Streams,
    # so use selenium_chrome_headless for full JS/Turbo behavior
    driven_by(:selenium_chrome_headless)
  end

  it 'displays the new quest form' do
    visit root_path

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('My Academy Quests')

    # Check input field exists
    expect(page).to have_field('quest_title', placeholder: 'Yo, add new??')

    # Check submit button exists
    expect(page).to have_button('Create Quest')
  end

  it 'adds and then deletes a quest' do
    visit root_path

    # Create a quest
    fill_in 'quest_title', with: 'Quest to Delete'
    click_button 'Create Quest'

    expect(page).to have_content('Quest to Delete')

    # Find the turbo_frame for this quest and click delete
    quest_frame = find("turbo-frame[id^='quest_']", text: 'Quest to Delete')
    within(quest_frame) do
      find('button[title="Delete quest"]').click
    end

    # Wait for Turbo Stream to remove it
    expect(page).not_to have_content('Quest to Delete')
  end
end
