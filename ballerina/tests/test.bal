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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.ebay.com/sell/logistics/v1_beta" : "http://localhost:9090/sell/logistics/v1_beta";
final string token = isLiveServer ? os:getEnv("EBAY_ACCESS_TOKEN") : "test_token";
final string marketplaceId = "EBAY_US";

final Client ebay = check new ({
    auth: {token},
    httpVersion: http:HTTP_1_1
}, serviceUrl);

const string QUOTE_ID = "SQ-5f1c2a90";
const string SHIPMENT_ID = "SHP-7c41e8d2";

final ShippingQuoteRequest quoteRequest = {
    orders: [{orderId: "27-11033-48501", channel: "EBAY"}],
    packageSpecification: {
        dimensions: {unit: "INCH", length: "10", width: "8", height: "4"},
        weight: {unit: "POUND", value: "2.5"}
    },
    shipFrom: {
        fullName: "Jordan Ellis",
        primaryPhone: {phoneNumber: "4085550134"},
        contactAddress: {
            addressLine1: "2145 Hamilton Ave",
            city: "San Jose",
            stateOrProvince: "CA",
            postalCode: "95125",
            county: "Santa Clara",
            countryCode: "US"
        }
    },
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
    }
};

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateShippingQuote() returns error? {
    ShippingQuote quote = check ebay->createShippingQuote({xEBAYCMARKETPLACEID: marketplaceId, contentType: "application/json"}, quoteRequest);
    test:assertTrue(quote.shippingQuoteId is string);
    test:assertTrue((quote.rates ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetShippingQuote() returns error? {
    ShippingQuote quote = check ebay->getShippingQuote(QUOTE_ID);
    test:assertEquals(quote.shippingQuoteId, QUOTE_ID);
    test:assertTrue((quote.rates ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateFromShippingQuote() returns error? {
    // A live run would buy a real shipping label.
    if isLiveServer {
        return;
    }
    Shipment shipment = check ebay->createFromShippingQuote(
        {xEBAYCMARKETPLACEID: marketplaceId, contentType: "application/json"},
        {shippingQuoteId: QUOTE_ID, rateId: "rate-usps-priority-001"});
    test:assertTrue(shipment.shipmentId is string);
    test:assertEquals(shipment.rate?.rateId, "rate-usps-priority-001");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetShipment() returns error? {
    Shipment shipment = check ebay->getShipment(SHIPMENT_ID);
    test:assertEquals(shipment.shipmentId, SHIPMENT_ID);
    test:assertTrue(shipment.orders.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDownloadLabelFile() returns error? {
    http:Response response = check ebay->downloadLabelFile(SHIPMENT_ID, {accept: "application/pdf"});
    test:assertEquals(response.statusCode, 200);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCancelShipment() returns error? {
    if isLiveServer {
        return;
    }
    Shipment shipment = check ebay->cancelShipment(SHIPMENT_ID);
    test:assertEquals(shipment.cancellation?.cancellationStatus, "CANCELLATION_ACCEPTED");
}
