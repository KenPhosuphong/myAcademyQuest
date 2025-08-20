require 'rails_helper'

RSpec.describe "Quests", type: :system do
  it 'creates a new quest' do
    visit root_path
    expect(page).to have_current_path(root_path)
  end
end
