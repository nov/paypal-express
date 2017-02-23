## v1.2.1
__Updated:__
- Subscription amendment now takes mandatory currency_code option.

```rb
Paypal::Express::Request.new(params).amend!("profile_id", {amount: 19.95, currency_code: "EUR", note: "will show up in email and profile logs"})
```

## v1.2.0
__Added:__
- Ability to amend a created paypal subscription (its amount)

```rb
Paypal::Express::Request.new(params).amend!("profile_id", {amount: 19.95, note: "will show up in email and profile logs"})
```

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
