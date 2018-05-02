module SpreeAbandonedCarts
  class Configuration < Spree::Preferences::Configuration
    preference :abandoned_states, :array, default: [:cart, :address, :delivery, :payment, :confirm]
    preference :abandoned_after_minutes, :integer, default: 24.hours / 1.minute
    preference :worker_frequency_minutes, :integer, default: 30.minutes
    preference :days_before_too_old, :integer, default: 5.days
  end
end
