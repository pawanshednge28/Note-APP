class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = Note.all.order(created_at: :desc)
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end


  # POST /notes or /notes.json
  def create
    @note = current_user.notes.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to root_path, notice: "Note was successfully created." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(
              "notes_list",
              partial: "home/notes_list",
              locals: { notes: current_user.notes.order(created_at: :desc) }
            ),
            turbo_stream.update(
              "new_note_form",
              partial: "home/form",
              locals: { note: Note.new }
            ),
            turbo_stream.update("modal", "")
          ]
        end
        format.json { render root_path, status: :created, location: @note }
      else
        @notes = current_user.notes.order(created_at: :desc)
        format.html { render 'home/index', status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(
              "notes_list",
              partial: "home/notes_list",
              locals: { notes: @notes }
            ),
            turbo_stream.update(
              "new_note_form",
              partial: "home/form",
              locals: { note: @note }
            ),
            turbo_stream.update(
              "modal",
              "" # ensure modal is closed if open
            )
          ], status: :unprocessable_entity
        end
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end

    
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def edit
    @note = current_user.notes.find(params[:id])
  
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "modal",
          partial: "form_modal",
          locals: { note: @note }
        )
      end
      format.html { render :edit }
    end
  end
  
  
  
  def update
    @note = current_user.notes.find(params[:id])
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to root_path, notice: "Note updated!" }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(
              "notes_list",
              partial: "home/notes_list",
              locals: { notes: current_user.notes.order(created_at: :desc) }
            ),
            turbo_stream.update("modal", "")
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "modal",
            partial: "form_modal",
            locals: { note: @note }
          ), status: :unprocessable_entity
        end
      end
    end
  end
  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, allow_other_host: false, notice: "Note deleted!" }
      format.turbo_stream { redirect_to root_path }
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :file, :user_id)
    end
end
