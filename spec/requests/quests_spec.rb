require 'rails_helper'

RSpec.describe "/quests", type: :request do
  let(:valid_attributes) do
    {
      title: "My Quest",
      status: "pending"
    }
  end

  let(:invalid_attributes) do
    {
      title: "",  
      status: nil
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      Quest.create!(valid_attributes)
      get quests_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Quest (html)" do
        expect {
          post quests_url, params: { quest: valid_attributes }
        }.to change(Quest, :count).by(1)
      end

      it "creates a new Quest (turbo_stream)" do
        expect {
          post quests_url, params: { quest: valid_attributes }, headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
        }.to change(Quest, :count).by(1)
        expect(response.media_type).to eq "text/vnd.turbo-stream.html"
        expect(response.body).to include("turbo-stream")
      end

      it "redirects to the created quest (html)" do
        post quests_url, params: { quest: valid_attributes }
        expect(response).to redirect_to(quest_url(Quest.last))
      end

    end

    context "with invalid parameters" do
      it "does not create a new Quest" do
        expect {
          post quests_url, params: { quest: invalid_attributes }
        }.not_to change(Quest, :count)
      end

      it "renders a response with 422 status (html)" do
        post quests_url, params: { quest: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    let(:quest) { Quest.create!(valid_attributes) }
    let(:new_attributes) do
      {
        title: "Updated Quest",
        status: "completed"
      }
    end

    it "updates and returns turbo_stream (turbo_stream)" do
      patch quest_url(quest), params: { quest: new_attributes }, headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      quest.reload
      expect(response).to be_successful
      expect(response.body).to include("turbo-stream")
    end
  end

  describe "DELETE /destroy" do
    let!(:quest) { Quest.create!(valid_attributes) }

    it "destroys the requested quest (html)" do
      expect {
        delete quest_url(quest)
      }.to change(Quest, :count).by(-1)
      expect(response).to redirect_to(quests_url)
    end

    it "destroys the requested quest (turbo_stream)" do
      expect {
        delete quest_url(quest), headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      }.to change(Quest, :count).by(-1)
      expect(response).to be_successful
      expect(response.body).to include("turbo-stream")
    end
  end
end