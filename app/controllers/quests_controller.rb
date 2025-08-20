class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ update destroy ]

  # GET /quests or /quests.json
  def index
    @quests = Quest.order(created_at: :desc)  # Newest first
    @quest = Quest.new  # For the new quest form
  end

  # POST /quests or /quests.json
  def create
    @quest = Quest.new(quest_params)

    respond_to do |format|
      if @quest.save
        format.turbo_stream do
          render turbo_stream: [
            # Since we're sorting newest first, prepend works perfectly
            turbo_stream.prepend("quests", partial: "quests/quest_row", locals: { quest: @quest }),
            turbo_stream.replace("new_quest_form", partial: "quests/new_quest_form", locals: { quest: Quest.new }),
            turbo_stream.remove("no_quests_message")
          ]
        end
        format.html { redirect_to @quest, notice: "Quest was successfully created." }
        format.json { render :show, status: :created, location: @quest }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_quest_form", partial: "quests/new_quest_form", locals: { quest: @quest })
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quests/1 or /quests/1.json
  def update
    respond_to do |format|
      if @quest.update(quest_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "quest_#{@quest.id}",
            partial: "quests/quest_row",
            locals: { quest: @quest }
          )
        end
        format.html { redirect_to @quest, notice: "Quest was successfully updated." }
        format.json { render :show, status: :ok, location: @quest }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "quest_#{@quest.id}",
            partial: "quests/quest_row",
            locals: { quest: @quest }
          )
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quests/1 or /quests/1.json
  def destroy
    @quest.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("quest_#{@quest.id}") }
      format.html { redirect_to quests_path, notice: "Quest was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    def set_quest
      @quest = Quest.find(params.expect(:id))
    end

    def quest_params
      params.expect(quest: [ :title, :status ])
    end
end
