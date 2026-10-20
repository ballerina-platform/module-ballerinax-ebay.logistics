// Review a purchased shipment against its original quote and cancel it when requested.

import ballerina/io;
import ballerinax/ebay.logistics;

configurable string accessToken = ?;
configurable string shipmentId = ?;
configurable boolean cancelShipment = false;

public function main() returns error? {
    logistics:Client ebay = check new ({auth: {token: accessToken}});

    // Step 1: Load the shipment.
    logistics:Shipment shipment = check ebay->getShipment(shipmentId);
    io:println("Shipment ", shipmentId, " tracking number: ", shipment.shipmentTrackingNumber);

    // Step 2: Load the quote the shipment was purchased from and compare costs.
    string? quoteId = shipment.rate?.shippingQuoteId;
    if quoteId is () {
        return error("Shipment " + shipmentId + " does not reference a shipping quote");
    }
    logistics:ShippingQuote quote = check ebay->getShippingQuote(quoteId);
    io:println("Quote ", quoteId, " offered ", (quote.rates ?: []).length(), " rate(s); purchased total: ",
            shipment.rate?.totalShippingCost?.value);

    // Step 3: Cancel only when explicitly requested.
    if !cancelShipment {
        io:println("Set cancelShipment = true to cancel this shipment.");
        return;
    }
    logistics:Shipment cancelled = check ebay->cancelShipment(shipmentId);
    io:println("Cancellation status: ", cancelled.cancellation?.cancellationStatus);
}
