require 'stripe'
require 'date'
require 'set'

class StripeDeclineRate
  def initialize(api_key)
    Stripe.api_key = api_key
  end

  def latest
    saturday = starting_saturday
    sunday = starting_sunday

    10.times do |i|
      puts "#{sunday} through #{saturday}: #{formatted_decline_ratio(sunday, saturday)}"

      sunday = sunday - 7
      saturday = saturday - 7
    end
  end

  def starting_saturday
    (Date.today - Date.today.wday).prev_day
  end

  def starting_sunday
    Date.today - Date.today.wday - 7
  end

  def formatted_decline_ratio(from, to)
    "#{(decline_ratio(from, to) * 100).round(2)}%"
  end

  def decline_ratio(from, to)
    declined_count = declined_charge_fingerprints(from, to).count
    successful_count = successful_charge_fingerprints(from, to).count
    declined_count.to_f / (declined_count + successful_count).to_f
  end

  def successful_charge_fingerprints(from, to)
    charge_fingerprints(successful_charge_params(from, to))
  end

  def declined_charge_fingerprints(from, to)
    charge_fingerprints(decline_charge_params(from, to))
  end

  def successful_charge_params(from, to)
    base_params(from, to).merge({
      type: 'charge.succeeded'
    })
  end

  def decline_charge_params(from, to)
    base_params(from, to).merge({
      type: 'charge.failed'
    })
  end

  def base_params(from, to)
    {
      limit: 100,
      created: {
        gte: from.to_time.to_i,
        lt: to.to_time.to_i
      }
    }
  end

  def charge_fingerprints(params)
    list = Stripe::Event.all(params)
    fingerprints = unique_fingerprints(list)
    while list[:has_more] do
      last_event_id = list[:data].last[:id]
      list = Stripe::Event.all(params.merge(starting_after: last_event_id))
      fingerprints.merge(unique_fingerprints(list))
    end
    fingerprints
  end

  def unique_fingerprints(list)
    list[:data].map do |event|
      event[:data][:object][:source][:fingerprint]
    end.to_set
  end
end
