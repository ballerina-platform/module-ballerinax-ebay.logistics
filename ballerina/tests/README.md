# Tests

The test suite covers every operation of the connector: creating and retrieving shipping quotes, creating and retrieving shipments, downloading shipping labels and cancelling shipments.

By default the tests run against a mock server (`tests/mock_service.bal`) that serves schema-shaped shipments and shipping quotes on `http://localhost:9090`, so no credentials are required.

To run the tests against the live eBay Logistics API, set the following environment variables:

| Variable | Description |
|----------|-------------|
| `IS_LIVE_SERVER` | Set to `true` to target `https://api.ebay.com/sell/logistics/v1_beta` |
| `EBAY_ACCESS_TOKEN` | eBay user access token with the `https://api.ebay.com/oauth/api_scope/sell.logistics` scope |

The live tests read quote and shipment IDs that exist in the mock only; adapt the constants in `tests/test.bal` before running them against a real seller account. The cancellation test is skipped on the live server.

## Running Tests

```bash
bal test
```
