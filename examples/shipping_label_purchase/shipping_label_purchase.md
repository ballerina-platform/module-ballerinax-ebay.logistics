# Shipping label purchase

This example requests live shipping rates for an eBay order, selects the cheapest rate for the shipping service the buyer selected, buys it to create a shipment and downloads the resulting shipping label as a PDF file.

The order details do not include the buyer's selected shipping service, so you supply it as `shippingServiceCode`. Do not fulfill the order with a rate for any other service.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- Access to the eBay Logistics API, a limited release API available only to partners approved by eBay
- A payment method set up in the seller's eBay account, which eBay requires before a shipment can be created
- An eBay user access token with the `https://api.ebay.com/oauth/api_scope/sell.logistics` scope
- Create a `Config.toml` in this directory:

  ```toml
  accessToken = "<Access Token>"
  orderId = "<eBay Order ID>"
  shippingServiceCode = "<Shipping service code the buyer selected, e.g. USPSPriority>"
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
