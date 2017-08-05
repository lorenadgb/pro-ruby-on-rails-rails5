class Message < ApplicationRecord

  belongs_to :chef

  validates :content, :chef_id, presence: true

  def self.most_recent
    order(:created_at).last(20)
  end
end
