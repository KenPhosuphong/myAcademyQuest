require 'rails_helper'

RSpec.describe "quests/index", type: :view do
  before(:each) do
    assign(:quests, [
      Quest.create!(
        title: "Title",
        status: false
      ),
      Quest.create!(
        title: "Title",
        status: false
      )
    ])
  end

  it "renders a list of quests" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 0
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 0
  end
end
