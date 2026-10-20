# Shipping label purchase

This example requests live shipping rates for an eBay order, selects the cheapest rate, buys it to create a shipment and downloads the resulting shipping label as a PDF file.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An eBay user access token with the `https://api.ebay.com/oauth/api_scope/sell.logistics` scope
- Create a `Config.toml` in this directory:

  ```toml
  accessToken = "<Access Token>"
  orderId = "<eBay Order ID>"
  shipFromName = "<Sender name>"
  shipFromPhone = "<Sender phone>"
  shipFromStreet = "<Sender street>"
  shipFromCity = "<Sender city>"
  shipFromState = "<Sender state>"
  shipFromPostalCode = "<Sender postal code>"
  shipFromCounty = "<Sender county>"
  shipToName = "<Recipient name>"
  shipToPhone = "<Recipient phone>"
  shipToStreet = "<Recipient street>"
  shipToCity = "<Recipient city>"
  shipToState = "<Recipient state>"
  shipToPostalCode = "<Recipient postal code>"
  shipToCounty = "<Recipient county>"
  marketplaceId = "EBAY_US"
  packageWeight = "2.5"
  labelOutputPath = "label.pdf"
  ```

## Run the example

```bash
bal run
```
