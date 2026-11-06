# Shipment cancellation review

This example loads a purchased shipment together with the shipping quote it was bought from, prints the quoted and purchased costs, and cancels the shipment only when cancellation is explicitly requested.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- Access to the eBay Logistics API, a limited release API available only to partners approved by eBay
- An eBay user access token with the `https://api.ebay.com/oauth/api_scope/sell.logistics` scope
- Create a `Config.toml` in this directory:

  ```toml
  accessToken = "<Access Token>"
  shipmentId = "<Shipment ID>"
  cancelShipment = false
  ```

## Run the example

```bash
bal run
```
