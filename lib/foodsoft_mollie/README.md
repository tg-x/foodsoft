FoodsoftMollie
==============

This project adds support for iDEAL payments using Mollie to Foodsoft.

* Make sure the gem is uncommented in foodsoft's `Gemfile`
* Enter your Mollie account details in `config/app_config.yml`

```yaml
  # Mollie payment settings
  mollie:
    partner_id: 1234567
    profile_key: 89ABCDEF
    test_mode: true          # set to false on production
    transaction_fee: 1.20    # transaction fee (incl. tax; none by default)
```

At this moment, the transaction fee is not used. But the idea is that
the transaction fee will be added on each payment when set; it is not set by default,
meaning that the foodcoop will pay any transaction costs (out of the margin).

To initiate a payment, redirect to `new_payments_mollie_path` at `/:foodcoop/payments/mollie/new`.
The following url parameters are recognised:
* ''amount'' - default amount to charge (optional)
* ''fixed'' - when "true", the amount cannot be changed (optional)
* ''title'' - page title (optional)
* ''label'' - label for amount (optional)

This plugin also introduces the foodcoop config option `use_mollie`, which can
be set to `false` to disable this plugin's functionality. May be useful in
multicoop deployments.
