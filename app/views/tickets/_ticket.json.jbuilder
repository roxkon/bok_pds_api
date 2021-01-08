json.extract! ticket, :id, :title, :type, :order, :description, :duedate, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
