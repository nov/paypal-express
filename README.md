# paypal-express

Handle PayPal Express Checkout.
Both Instance Payment and Recurring Payment are supported.
Express Checkout for Digital Goods is also supported.

## Installation

```rb
gem "creative-paypal-express", "~> 1.0.0"
```

  gem install paypal-express

## Usage

See Wiki on Github
https://github.com/nov/paypal-express/wiki

Play with Sample Rails App
https://github.com/nov/paypal-express-sample
https://paypal-express-sample.heroku.com

## v1.1.0 news (not in wiki)
### Paypal::Payment::Recurring
The helper object can be instantiated by using the :raw key.  

```rb
params = {
  # optional initial payment parameters
  :INITAMT => "9.00",
  :FAILEDINITAMTACTION => "CancelOnFailure", # or "ContinueOnFailure"

  # optional trial parameters
  :TRIALBILLINGPERIOD => "Day",
  :TRIALBILLINGFREQUENCY => "7",
  :TRIALAMT => "0.00",
  :TRIALCURRENCYCODE => "EUR",
  :TRIALTOTALBILLINGCYCLES => "1",

  # mandatory regular recurring profile parameters
  :DESC => "Funny Movie Clips Subscription",
  :PROFILESTARTDATE => "2017-01-25T15:00:00Z",
  :BILLINGPERIOD => "Day", # "Month", "Year"
  :BILLINGFREQUENCY => "30",
  :AMT => "9.00", # two-decimals for cents, whole number for whole currency, like a Euro or Dollar
  :CURRENCYCODE => "EUR",

  # termination
  :TOTALBILLINGCYCLES => "0", # optional field, '0' value makes profile last forever
  :MAXFAILEDPAYMENTS => "3",
  :AUTOBILLAMT => "AddToNextBilling",

  # Digital goods fields
  :L_PAYMENTREQUEST_0_ITEMCATEGORY0 => "Digital",
  :L_PAYMENTREQUEST_0_NAME0 => "Cat Clip Collection",
  :L_PAYMENTREQUEST_0_AMT0 => "9.00",
  :L_PAYMENTREQUEST_0_QTY0 => "1",
}

recurring_profile = Paypal::Payment::Recurring.new(raw: params)
```

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 nov matake. See LICENSE for details.
