# Ballerina eBay Logistics connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-ebay.logistics/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.logistics/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-ebay.logistics.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.logistics/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/ebay.logistics.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Febay.logistics)

## Overview

[eBay](https://www.ebay.com/) is a global online marketplace where businesses and individuals buy and sell goods. The eBay Logistics API lets approved sellers get live shipping rates, buy shipping labels and manage the resulting shipments through eBay.

The ebay logistics connector provides a Ballerina client for version `v1_beta` of the eBay Logistics API, so you can request shipping quotes, purchase rates and handle shipments from your integrations. The API is a limited release available only to developers approved by eBay.

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

1. [Shipping label purchase](examples/shipping_label_purchase/shipping_label_purchase.md) - Request shipping rates for an order, buy the cheapest rate for the buyer's selected shipping service and download the shipping label.
2. [Shipment cancellation review](examples/shipment_cancellation_review/shipment_cancellation_review.md) - Review a purchased shipment against its original quote and cancel it when requested.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`ebay.logistics` package](https://central.ballerina.io/ballerinax/ebay.logistics/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
