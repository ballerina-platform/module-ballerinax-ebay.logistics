_Author_:  @DimuthuMadushan \
_Created_: 2026/10/20 \
_Updated_: 2026/10/20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from eBay Logistics.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/ebay/logistics/v1_beta/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Changed the OpenAPI version from `3.1.0` to `3.0.1` in `docs/spec/openapi.json`. The flatten and align steps drop the `type` of every schema and parameter from an OpenAPI 3.1 document, which turned all primitive properties into `anydata` and the header parameters into empty schemas, and produced a redeclared `xEBAYCMARKETPLACEID` header field. The specification uses no 3.1-only constructs, so the version change is lossless. This change is made in the original spec.

2. Changed the `type` of the enum schemas `CountryCodeEnum`, `CurrencyCodeEnum`, `LengthUnitOfMeasureEnum`, `PickupTypeEnum`, `RateRecommendationEnum`, `ShipmentCancellationStatusEnum` and `WeightUnitOfMeasureEnum` from `object` to `string`, in `docs/spec/openapi.json`. Each already lists its values under `enum`, so they now generate as string unions rather than empty records. This change is made in the original spec.

3. Added a short `summary` to each of the six operations (`cancelShipment`, `createFromShippingQuote`, `downloadLabelFile`, `getShipment`, `createShippingQuote` and `getShippingQuote`), which the original specification does not provide, in `docs/spec/openapi.json`. This change is made in the original spec.

4. Replaced the templated server URL `https://api.ebay.com{basePath}` (with a `basePath` variable defaulting to `/sell/logistics/v1_beta`) with the concrete URL `https://api.ebay.com/sell/logistics/v1_beta`, in `docs/spec/openapi.json`. This change is made in the original spec.

5. Rewrote the generic `Success` descriptions of the `200` responses of `cancelShipment`, `downloadLabelFile`, `getShipment` and `getShippingQuote` to describe the returned content, in `docs/spec/openapi.json`. This change is made in the original spec.

6. Replaced the HTML-formatted `info.description` with a short plain-text description of the API, in `docs/spec/openapi.json`. The generated client's documentation comment is taken from this field. This change is made in the original spec.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```

Note: The license year is hardcoded to 2026, change if necessary.
