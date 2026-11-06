
// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

listener http:Listener ep0 = new (9090);

final readonly & Contact mockContact = {
    fullName: "Jordan Ellis",
    companyName: "Ellis Vintage Goods",
    primaryPhone: {phoneNumber: "4085550134"},
    contactAddress: {
        addressLine1: "2145 Hamilton Ave",
        city: "San Jose",
        stateOrProvince: "CA",
        postalCode: "95125",
        county: "Santa Clara",
        countryCode: "US"
    }
};

function mockShipment(string shipmentId, string status) returns Shipment => {
    shipmentId,
    shipmentTrackingNumber: "9400111899223197428490",
    creationDate: "2026-03-14T17:21:05.000Z",
    labelDownloadUrl: "https://api.ebay.com/sell/logistics/v1_beta/shipment/" + shipmentId + "/download_label_file",
    labelSize: "4\"x6\"",
    labelCustomMessage: "Handle with care",
    orders: [{orderId: "27-11033-48501", channel: "EBAY"}],
    packageSpecification: {
        dimensions: {unit: "INCH", length: "10", width: "8", height: "4"},
        weight: {unit: "POUND", value: "2.5"}
    },
    shipFrom: mockContact,
    shipTo: {
        fullName: "Maria Alvarez",
        primaryPhone: {phoneNumber: "5125550172"},
        contactAddress: {
            addressLine1: "88 Congress St",
            city: "Austin",
            stateOrProvince: "TX",
            postalCode: "78701",
            county: "Travis",
            countryCode: "US"
        }
    },
    rate: {
        rateId: "rate-usps-priority-001",
        shippingQuoteId: "SQ-5f1c2a90",
        shippingCarrierCode: "USPS",
        shippingCarrierName: "USPS",
        shippingServiceCode: "USPSPriority",
        shippingServiceName: "USPS Priority Mail",
        pickupType: "DROP_OFF",
        baseShippingCost: {currency: "USD", value: "8.45"},
        totalShippingCost: {currency: "USD", value: "8.45"}
    },
    cancellation: {cancellationStatus: <ShipmentCancellationStatusEnum>status}
};

function mockQuote(string quoteId) returns ShippingQuote => {
    shippingQuoteId: quoteId,
    creationDate: "2026-03-14T17:00:00.000Z",
    expirationDate: "2026-03-15T17:00:00.000Z",
    orders: [{orderId: "27-11033-48501", channel: "EBAY"}],
    packageSpecification: {
        dimensions: {unit: "INCH", length: "10", width: "8", height: "4"},
        weight: {unit: "POUND", value: "2.5"}
    },
    shipFrom: mockContact,
    rates: [
        {
            rateId: "rate-usps-priority-001",
            shippingCarrierCode: "USPS",
            shippingCarrierName: "USPS",
            shippingServiceCode: "USPSPriority",
            shippingServiceName: "USPS Priority Mail",
            pickupType: "DROP_OFF",
            minEstimatedDeliveryDate: "2026-03-18T00:00:00.000Z",
            maxEstimatedDeliveryDate: "2026-03-20T00:00:00.000Z",
            destinationTimeZone: "America/Chicago",
            baseShippingCost: {currency: "USD", value: "8.45"},
            rateRecommendation: ["CHEAPEST_ON_TIME"]
        },
        {
            rateId: "rate-usps-ground-002",
            shippingCarrierCode: "USPS",
            shippingCarrierName: "USPS",
            shippingServiceCode: "USPSGroundAdvantage",
            shippingServiceName: "USPS Ground Advantage",
            pickupType: "DROP_OFF",
            baseShippingCost: {currency: "USD", value: "5.20"}
        }
    ]
};

service /sell/logistics/v1_beta on ep0 {
    # Get a shipment
    #
    # + shipmentId - This path parameter specifies the unique eBay-assigned identifier of the shipment you want to retrieve.<br><br>The <strong>shipmentId</strong> value is generated and returned by the <a href="/api-docs/sell/logistics/resources/shipment/methods/createFromShippingQuote" target="_blank">createFromShippingQuote</a> method
    # + return - returns can be any of following types 
    # http:Ok (The retrieved shipment)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get shipment/[string shipmentId]() returns Shipment|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        if shipmentId == "unknown" {
            return <ErrorNotFound>{body: {errorId: 90001, domain: "API_LOGISTICS", message: "Shipment not found"}};
        }
        return mockShipment(shipmentId, "CANCELLATION_REQUESTED");
    }

    # Download a shipment label file
    #
    # + shipmentId - This path parameter specifies the unique eBay-assigned identifier of the shipment associated with the shipping label you want to download.<br><br> The <strong>shipmentId</strong> value is generated and returned by the <a href="/api-docs/sell/logistics/resources/shipment/methods/createFromShippingQuote" target="_blank">createFromShippingQuote</a> method
    # + accept - This header specifies the format of the returned file. For this method, the value of the header should be <code>Accept: application/pdf</code>. 
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get shipment/[string shipmentId]/download_label_file(@http:Header {name: "Accept"} string accept) returns http:Response {
        http:Response response = new;
        response.setBinaryPayload(("%PDF-1.4 mock shipping label for " + shipmentId).toBytes(), "application/pdf");
        return response;
    }

    # Get a shipping quote
    #
    # + shippingQuoteId - This path parameter specifies the unique eBay-assigned ID of the shipping quote you want to retrieve.<br><br>The <strong>shippingQuoteId</strong> value is generated and returned by the <a href="/api-docs/sell/logistics/resources/shipping_quote/methods/createShippingQuote" target="_blank">createShippingQuote</a> method
    # + return - returns can be any of following types 
    # http:Ok (The retrieved shipping quote)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get shipping_quote/[string shippingQuoteId]() returns ShippingQuote|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        if shippingQuoteId == "unknown" {
            return <ErrorNotFound>{body: {errorId: 90002, domain: "API_LOGISTICS", message: "Shipping quote not found"}};
        }
        return mockQuote(shippingQuoteId);
    }

    # Cancel a shipment
    #
    # + shipmentId - This path parameter specifies the unique eBay-assigned ID of the shipment to be canceled.<br><br>The <strong>shipmentId</strong> value is generated and returned by the <a href="/api-docs/sell/logistics/resources/shipment/methods/createFromShippingQuote" target="_blank">createFromShippingQuote</a> method
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function post shipment/[string shipmentId]/cancel() returns ShipmentOk|ErrorBadRequest|ErrorNotFound|ErrorConflict|ErrorInternalServerError {
        if shipmentId == "unknown" {
            return <ErrorNotFound>{body: {errorId: 90001, domain: "API_LOGISTICS", message: "Shipment not found"}};
        }
        return <ShipmentOk>{body: mockShipment(shipmentId, "CANCELLATION_ACCEPTED")};
    }

    # Create a shipment from a shipping quote
    #
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <strong>application/json</strong>. <br><br> For more information, refer to <a href="/api-docs/static/rest-request-components.html#HTTP" target="_blank ">HTTP request headers</a>
    # + xEBAYCMARKETPLACEID - This header parameter specifies the eBay marketplace for the shipment being created.<br><br>For a list of valid values, refer to the section <a href="/api-docs/static/rest-request-components.html#marketpl" target="_blank">Marketplace ID Values</a> in the <strong>Using eBay RESTful APIs</strong> guide
    # + payload - The create shipment from quote request 
    # + return - returns can be any of following types 
    # http:Created (Created)
    # http:BadRequest (Bad Request)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function post shipment/create_from_shipping_quote(@http:Header {name: "Content-Type"} string contentType, @http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} string xEBAYCMARKETPLACEID, @http:Payload CreateShipmentFromQuoteRequest payload) returns Shipment|ErrorBadRequest|ErrorConflict|ErrorInternalServerError {
        Shipment shipment = mockShipment("SHP-7c41e8d2", "CANCELLATION_REQUESTED");
        shipment.rate = {rateId: payload.rateId, shippingQuoteId: payload.shippingQuoteId, shippingCarrierCode: "USPS", shippingServiceName: "USPS Priority Mail", totalShippingCost: {currency: "USD", value: "8.45"}};
        return shipment;
    }

    # Create a shipping quote
    #
    # + xEBAYCMARKETPLACEID - This header parameter specifies the eBay marketplace for the shipping quote that is being created.<br><br>For a list of valid values, see <a href="/develop/api/sell/request_headers#marketplace-id-values " target="_blank ">Request Headers</a>
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <strong>application/json</strong>. <br><br> For more information, refer to <a href="/api-docs/static/rest-request-components.html#HTTP" target="_blank ">HTTP request headers</a>
    # + payload - The request object for <strong>createShippingQuote</strong> 
    # + return - returns can be any of following types 
    # http:Created (Created)
    # http:BadRequest (Bad Request)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function post shipping_quote(@http:Header {name: "X-EBAY-C-MARKETPLACE-ID"} string xEBAYCMARKETPLACEID, @http:Header {name: "Content-Type"} string contentType, @http:Payload ShippingQuoteRequest payload) returns ShippingQuote|ErrorBadRequest|ErrorConflict|ErrorInternalServerError {
        ShippingQuote quote = mockQuote("SQ-5f1c2a90");
        quote.orders = payload.orders;
        return quote;
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

public type ErrorConflict record {|
    *http:Conflict;
    Error body;
|};

public type ErrorInternalServerError record {|
    *http:InternalServerError;
    Error body;
|};

public type ErrorNotFound record {|
    *http:NotFound;
    Error body;
|};

public type ShipmentOk record {|
    *http:Ok;
    Shipment body;
|};

# This type defines the fields that can be returned in an error
public type Error record {
    # Name for the primary system where the error occurred. This is relevant for application errors
    string domain?;
    # Further helps indicate which subsystem the error is coming from. System subcategories include: Initialization, Serialization, Security, Monitoring, Rate Limiting, etc
    string subdomain?;
    # An array of request elements most closely associated to the error
    string[] outputRefIds?;
    # A unique number to identify the error
    int:Signed32 errorId?;
    # An array of request elements most closely associated to the error
    string[] inputRefIds?;
    # Identifies the type of error
    string category?;
    # A more detailed explanation of the error
    string longMessage?;
    # Information on how to correct the problem, in the end user's terms and language where applicable
    string message?;
    # An array of name/value pairs that describe details the error condition. These are useful when multiple errors are returned
    ErrorParameter[] parameters?;
};

# Name and value of a parameter that caused an error
public type ErrorParameter record {
    string name?;
    string value?;
};
