# spec/host/db/seeds.rb
# frozen_string_literal: true

45.times do |index|
  Product.create!(name: "Synthetic Product #{format('%02d', index + 1)}",
                  status: index.even? ? "ready" : "pending", quantity: index * 7,
                  description: "Synthetic operator fixture with a deliberately long identifier: #{'ABC-' * 20}",
                  available_on: Date.new(2026, 1, 15), created_at: Time.utc(2026, 1, 1),
                  updated_at: Time.utc(2026, 1, 1))
end
