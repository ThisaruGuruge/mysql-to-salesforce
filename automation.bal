import ballerina/log;
import ballerina/sql;
import ballerinax/salesforce;

public function main() returns error? {
    do {
        stream<ProductReceived, sql:Error?> streamOutput = mysql->query(`SELECT name, unitType, currencyISO, productId FROM products WHERE processed = false`);
        ProductReceived[] productsReceived = check from ProductReceived productReceived in streamOutput
            select productReceived;
        foreach ProductReceived productReceived in productsReceived {
            Product product = {Name: productReceived.name, Product_Unit__c: productReceived.unitType, CurrencyIsoCode: productReceived.currencyISO};
            salesforce:CreationResponse _ = check salesforce->create("Product2", product);
            sql:ExecutionResult _ = check mysql->execute(`UPDATE products SET processed = true WHERE productId = ${productReceived.productId}`);
        }
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
