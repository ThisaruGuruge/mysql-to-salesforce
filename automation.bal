import ballerina/log;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/salesforce;

public function main() returns error? {
    do {
        sql:ExecutionResult _ = check mysql->execute(`CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    unitType VARCHAR(50) NOT NULL,
    currencyISO VARCHAR(3) NOT NULL,
    productId VARCHAR(50) NOT NULL,
    processed BOOLEAN NOT NULL
)`
);
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
