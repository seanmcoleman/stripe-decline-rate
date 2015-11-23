Gem::Specification.new do |s|
  s.name        = 'stripe-decline-rate'
  s.version     = '0.0.2'
  s.date        = '2015-11-23'
  s.summary     = 'Easily track Stripe card decline rates.'
  s.description = 'Get visibility into actual ratios of successful charges and failed charge attempts unique to card numbers.'
  s.authors     = ["Sean Coleman"]
  s.email       = 'sean@seancoleman.net'
  s.files       = ["lib/stripe_decline_rate.rb"]
  s.homepage    = 'https://github.com/seanmcoleman/stripe-decline-rate'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_dependency 'stripe'
end
