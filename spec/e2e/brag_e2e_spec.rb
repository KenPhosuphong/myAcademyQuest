require 'rails_helper'

RSpec.describe "Brag", type: :system do
  it 'creates a new quest' do
    visit brag_path
    expect(page).to have_current_path(brag_path)
    expect(page).to have_content('My Brag Document')
  end
end
