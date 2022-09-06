# frozen_string_literal: true

module Spree
  class Favorite < ApplicationRecord
    FAVORABLES_ALLOWED = [
      'Spree::Product'
    ].freeze

    belongs_to :favorable, polymorphic: true
    belongs_to :user, class_name: Spree.user_class.to_s
    belongs_to :variant, class_name: 'Spree::Variant', optional: true

    validates :favorable, presence: true
    validates :favorable_type,
              presence: true,
              inclusion: {
                in: FAVORABLES_ALLOWED
              }

    validates :user_id,
              uniqueness: {
                allow_blank: true,
                message: 'Already added as favorite.',
                scope: [:favorable_id, :favorable_type]
              }
    validates :guest_token,
              uniqueness: {
                allow_blank: true,
                message: 'Already added as favorite.',
                scope: [:favorable_id, :favorable_type]
              }

    scope :by_guest_token, ->(token) { where(guest_token: token) }

    default_scope { order('created_at DESC') }
  end
end
