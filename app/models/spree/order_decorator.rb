module Spree
  Order.class_eval do
    scope :abandoned,
      -> {  start_at = Time.current - SpreeAbandonedCarts::Config.abandoned_after_minutes.minutes
            end_at = Time.current - SpreeAbandonedCarts::Config.days_before_too_old.days

            incomplete.
            where('email IS NOT NULL').
            where("#{quoted_table_name}.item_total > 0").
            where("#{quoted_table_name}.updated_at < ? AND #{quoted_table_name}.updated_at > ?", start_at, end_at) }

    scope :abandon_not_notified,
      -> { abandoned.where(abandoned_cart_email_sent_at: nil) }

    def abandoned_cart_actions
      AbandonedCartMailer.abandoned_cart_email(self).deliver_now
      touch(:abandoned_cart_email_sent_at)
    end

    def last_for_user?
      Order.where(email: email).where('id > ?', id).none?
    end
  end
end
