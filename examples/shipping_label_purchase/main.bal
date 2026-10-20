// Quote shipping rates for an order, buy the cheapest rate for the buyer's selected shipping service and download
// the shipping label.

import ballerina/http;
import ballerina/io;
import ballerinax/ebay.logistics;

configurable string accessToken = ?;
configurable string marketplaceId = "EBAY_US";
configurable string orderId = ?;
// The order does not carry the buyer's selected shipping service, so supply it here. Never fulfill the order with a
// rate for any other service.
configurable string shippingServiceCode = ?;
configurable string shipFromName = ?;
configurable string shipFromPhone = ?;
configurable string shipFromStreet = ?;
configurable string shipFromCity = ?;
configurable string shipFromState = ?;
configurable string shipFromPostalCode = ?;
configurable string shipFromCounty = ?;
configurable string shipToName = ?;
configurable string shipToPhone = ?;
configurable string shipToStreet = ?;
configurable string shipToCity = ?;
configurable string shipToState = ?;
configurable string shipToPostalCode = ?;
configurable string shipToCounty = ?;
configurable string packageWeight = "2.5";
configurable string labelOutputPath = "label.pdf";

public function main() returns error? {
    logistics:Client ebay = check new ({auth: {token: accessToken}});
    logistics:CreateShippingQuoteHeaders quoteHeaders = {xEBAYCMARKETPLACEID: marketplaceId, contentType: "application/json"};

    // Step 1: Request live shipping rates for the order.
    logistics:ShippingQuote quote = check ebay->createShippingQuote(quoteHeaders, {
        orders: [{orderId, channel: "EBAY"}],
        packageSpecification: {
            dimensions: {unit: "INCH", length: "10", width: "8", height: "4"},
            weight: {unit: "POUND", value: packageWeight}
        },
        shipFrom: {
            fullName: shipFromName,
            primaryPhone: {phoneNumber: shipFromPhone},
            contactAddress: {
                addressLine1: shipFromStreet,
                city: shipFromCity,
                stateOrProvince: shipFromState,
                postalCode: shipFromPostalCode,
                county: shipFromCounty,
                countryCode: "US"
            }
        },
        shipTo: {
            fullName: shipToName,
            primaryPhone: {phoneNumber: shipToPhone},
            contactAddress: {
                addressLine1: shipToStreet,
                city: shipToCity,
                stateOrProvince: shipToState,
                postalCode: shipToPostalCode,
                county: shipToCounty,
                countryCode: "US"
            }
        }
    });
    string quoteId = check quote.shippingQuoteId.ensureType();
    logistics:Rate[] rates = quote.rates ?: [];
    if rates.length() == 0 {
        return error("No shipping rates were returned for quote " + quoteId);
    }

    // Step 2: Pick the cheapest priced rate for the shipping service the buyer selected.
    logistics:Rate? cheapest = ();
    decimal cheapestCost = 0;
    foreach logistics:Rate rate in rates {
        string? cost = rate.baseShippingCost?.value;
        if rate.shippingServiceCode != shippingServiceCode || cost is () {
            continue;
        }
        decimal value = check decimal:fromString(cost);
        if cheapest is () || value < cheapestCost {
            cheapestCost = value;
            cheapest = rate;
        }
    }
    if cheapest is () {
        return error("No priced rate for shipping service " + shippingServiceCode + " in quote " + quoteId);
    }
    string rateId = check cheapest.rateId.ensureType();
    io:println("Selected rate ", rateId, " (", cheapest.shippingServiceName, ") at ", cheapestCost);

    // Step 3: Buy the rate and create the shipment.
    logistics:Shipment shipment = check ebay->createFromShippingQuote(quoteHeaders, {shippingQuoteId: quoteId, rateId});
    string shipmentId = check shipment.shipmentId.ensureType();
    io:println("Shipment ", shipmentId, " created, tracking number ", shipment.shipmentTrackingNumber);

    // Step 4: Download the shipping label.
    http:Response label = check ebay->downloadLabelFile(shipmentId, {accept: "application/pdf"});
    if label.statusCode < 200 || label.statusCode > 299 {
        return error(string `Label download failed with HTTP ${label.statusCode}: ${check label.getTextPayload()}`);
    }
    byte[] pdf = check label.getBinaryPayload();
    check io:fileWriteBytes(labelOutputPath, pdf);
    io:println("Label saved to ", labelOutputPath);
}
