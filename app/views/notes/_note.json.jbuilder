json.extract! note, :id, :title, :content, :file, :user_id, :created_at, :updated_at
json.url note_url(note, format: :json)
json.file url_for(note.file)
