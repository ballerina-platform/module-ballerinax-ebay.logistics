## Overview

[eBay](https://www.ebay.com/) is a global online marketplace where businesses and individuals buy and sell goods. The eBay Logistics API lets approved sellers get live shipping rates, buy shipping labels and manage the resulting shipments through eBay.

The ebay logistics connector provides a Ballerina client for version `v1_beta` of the eBay Logistics API, so you can request shipping quotes, purchase rates and handle shipments from your integrations. The API is a limited release available only to developers approved by eBay.

### Key features

- Request live shipping rates for one or more orders
- Create shipments from a selected shipping quote and rate
- Retrieve shipment and shipping quote details
- Download shipping labels for purchased shipments
- Cancel shipments and track the cancellation status

## Setup guide

To use the eBay Logistics connector you need an eBay developer account with access to the Logistics API, and a user access token that carries the `https://api.ebay.com/oauth/api_scope/sell.logistics` scope.

### Step 1: Create an eBay developer account

1. Sign up at the [eBay Developers Program](https://developer.ebay.com/) and sign in.
2. Request access to the Logistics API, which is a limited release API available only to developers approved by eBay.

### Step 2: Create an application keyset

1. Open the **Application Keysets** page in your developer account.
2. Create a keyset for the **Production** environment and note the **App ID (Client ID)** and **Cert ID (Client Secret)**.
3. Configure an OAuth redirect URL (RuNa) for the keyset.

### Step 3: Obtain an access token

1. Direct the seller to the eBay consent page (`https://auth.ebay.com/oauth2/authorize`) with the `https://api.ebay.com/oauth/api_scope/sell.logistics` scope to obtain an authorization code.
2. Exchange the authorization code for a user access token and a refresh token at `https://api.ebay.com/identity/v1/oauth2/token`.
3. Use the access token directly, or use the refresh token together with the client ID and client secret so that the connector can renew the access token.

## Quickstart

To use the `ebay.logistics` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/ebay.logistics;
```

### Step 2: Instantiate a new connector

Create a `Config.toml` file with your access token:

```toml
accessToken = "<Access Token>"
```

Then create a client:

```ballerina
configurable string accessToken = ?;

final logistics:Client ebay = check new ({auth: {token: accessToken}});
```

### Step 3: Invoke the connector operation

```ballerina
public function main() returns error? {
    logistics:ShippingQuote _ = check ebay->getShippingQuote("<Shipping Quote ID>");
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `eBay Logistics` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-ebay.logistics/tree/main/examples/), covering the following use cases:

1. [Shipping label purchase](https://github.com/ballerina-platform/module-ballerinax-ebay.logistics/tree/main/examples/shipping_label_purchase) - Request shipping rates for an order, buy the cheapest rate for the buyer's selected shipping service and download the shipping label.
2. [Shipment cancellation review](https://github.com/ballerina-platform/module-ballerinax-ebay.logistics/tree/main/examples/shipment_cancellation_review) - Review a purchased shipment against its original quote and cancel it when requested.
