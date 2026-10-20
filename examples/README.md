# Examples

The `ballerinax/ebay.logistics` connector provides practical examples illustrating usage in various scenarios.

| Example | Description |
|---------|-------------|
| [`shipping_label_purchase`](./shipping_label_purchase/shipping_label_purchase.md) | Request shipping rates for an order, buy the cheapest rate for the buyer's selected shipping service and download the shipping label. |
| [`shipment_cancellation_review`](./shipment_cancellation_review/shipment_cancellation_review.md) | Review a purchased shipment against its original quote and cancel it when requested. |

## Prerequisites

1. Access to the eBay Logistics API, a limited release API available only to partners approved by eBay.
2. An eBay user access token with the `https://api.ebay.com/oauth/api_scope/sell.logistics` scope.
3. For the `shipping_label_purchase` example, a payment method set up in the seller's eBay account, which eBay requires before a shipment can be created.
4. For each example, create a `Config.toml` in the example directory with the required values, as described in the example's documentation.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
