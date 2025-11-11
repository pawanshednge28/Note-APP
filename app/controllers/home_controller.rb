class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @note = Note.new
    @notes = current_user.notes.order(created_at: :desc)
  end
end
