class Wishlist < ApplicationRecord
  belongs_to :product
  belongs_to :user, foreign_key: "username", primary_key: "username"

  def labels_array
    labels.present? ? labels.split(",").map(&:strip) : []
  end

  def add_label(label)
    current_labels = labels_array
    unless current_labels.include?(label)
      current_labels << label
      update(labels: current_labels.join(","))
    end
  end

  def remove_label(label)
    current_labels = labels_array
    if current_labels.include?(label)
      current_labels.delete(label)
      update(labels: current_labels.join(","))
    end
  end

  def self.filter_by_label(label)
    where("labels LIKE ?", "%#{label}%")
  end
end
