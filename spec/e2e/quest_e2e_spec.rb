require 'rails_helper'

RSpec.describe "Quests", type: :system do
  before do
    driven_by(:rack_test) # Or :selenium_chrome_headless if you want JS/animations
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

  it 'adds a new quest successfully' do
    visit root_path

    fill_in 'quest_title', with: 'New Quest'
    click_button 'Create Quest'

    # After submit, we should see the new quest text
    expect(page).to have_content('New Quest')
  end
end
