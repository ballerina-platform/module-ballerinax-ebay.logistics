# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Typed headers records for the operations that need request headers: `CreateShippingQuoteHeaders` and `CreateFromShippingQuoteHeaders` (the required `X-EBAY-C-MARKETPLACE-ID` and `Content-Type`), and `DownloadLabelFileHeaders` (the required `Accept`).
- An optional `headers` parameter on `getShippingQuote`, `getShipment` and `cancelShipment`, for sending extra request headers.
- String-union types for the enumerated values: `CountryCodeEnum`, `CurrencyCodeEnum`, `LengthUnitOfMeasureEnum`, `PickupTypeEnum`, `RateRecommendationEnum`, `ShipmentCancellationStatusEnum` and `WeightUnitOfMeasureEnum`.
- New `ConnectionConfig` fields, taken from `http:ClientConfiguration`: `followRedirects`, `cookieConfig`, `socketConfig` and `laxDataBinding`.

### Changed

- **Breaking:** `createShippingQuote` and `createFromShippingQuote` take a required headers record before the payload:

    ```ballerina
    // 1.5.2
    logistics:ShippingQuote quote = check ebay->createShippingQuote(quoteRequest);
    ```

    ```ballerina
    // 2.0.0
    logistics:ShippingQuote quote = check ebay->createShippingQuote(
        {xEBAYCMARKETPLACEID: "EBAY_US", contentType: "application/json"}, quoteRequest);
    ```

- **Breaking:** `downloadLabelFile` takes a required `DownloadLabelFileHeaders` record and returns `http:Response` (was `string[]`). Read the label file from the response.
- **Breaking:** fields that hold an enumerated value use the new string-union types (was `string`): `Amount.currency`, `ContactAddress.countryCode`, `Dimensions.unit`, `Weight.unit`, `Rate.pickupType`, `Rate.rateRecommendation`, `PurchasedRate.pickupType` and `ShipmentCancellation.cancellationStatus`.
- **Breaking:** fields that the API requires are no longer optional: `Amount.value`, `Contact.contactAddress`, `Contact.fullName`, `Contact.primaryPhone`, `ContactAddress.addressLine1`, `ContactAddress.countryCode`, `ContactAddress.county`, `ContactAddress.postalCode`, `CreateShipmentFromQuoteRequest.rateId`, `CreateShipmentFromQuoteRequest.shippingQuoteId`, `Order.channel`, `Order.orderId`, `PhoneNumber.phoneNumber`, `Shipment.orders`, `ShippingQuote.orders`, `ShippingQuoteRequest.orders`, `ShippingQuoteRequest.packageSpecification`, `ShippingQuoteRequest.shipFrom`, `ShippingQuoteRequest.shipTo`, `Weight.unit` and `Weight.value`.
- **Breaking:** `ShippingQuote.warnings` is an `ErrorDetailV3[]` (was `Error[]`), whose `parameters` are `ErrorParameterV3` records and whose `errorId` is an `int:Signed32`.
- **Breaking:** `ConnectionConfig.http1Settings` is now `http:ClientHttp1Settings` (was the connector's own `ClientHttp1Settings`).
- `ConnectionConfig.timeout` defaults to 30 seconds (was 60).

### Removed

- **Breaking:** the `Error` and `ErrorParameter` records. Use `ErrorDetailV3` and `ErrorParameterV3`.
- **Breaking:** the `StringArr` type alias (`string[]`).
- **Breaking:** the connector's own `ClientHttp1Settings` and `ProxyConfig` records. Use `http:ClientHttp1Settings` and `http:ProxyConfig` instead.
