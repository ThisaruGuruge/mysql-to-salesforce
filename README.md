# Steps to Follow

## Create MySQL Client Artifact

1. Go to "Add Artifact", click "Connections", and select "MySQL Client" under the "Database" category.
2. Provide the variable name as `mysql`.
3. Then click on "Expand" button under "Advanced Configurations" section.
4. Under the `host` field, click on the text field and when the "Expression Helper" appears, click on the
   "Configurables" tab.
5. Click on "Create New Configurable Variable" and provide the following values:
    - Name: `host`
    - Type: `string`
    Then click on "save" button.
    Do the same for the `port`, `user`, `password`, and `database` fields.
6. Click on the "Save" button to save the artifact.

## Create SalesForce Client Artifact

1. Click on "Add Artifact", click "Connections", and select "SalesForce Client" under the "SaaS" category.
2. Provide the variable name as `salesforce`.
3. Under the "Config" section, click on the text field, then click on "ConnectionConfig" tick box. This will add a
   constructor expression in the text box.
4. Then inside the expression, remove the double quotes (`""`) for the `baseUrl`.
5. Then in the Expression Helper, click on "Configurables" tab.
6. Click on "Create New Configurable Variable" and provide the following values:
    - Name: `salesforceBaseUrl`
    - Type: `string`
    Then click on "save" button.
    Do the same for the `token` field using a new configurable variable named `salesforceAccessToken`.
7. Click on the "Save" button to save the artifact.

## Create an Automation

1. Click on "Add Artifact", then click on "Automation".
2. Then click "Create" button.
3. In the diagram, click on `+` button to add a new node.
4. Under the right pane, click on dropdown under the `mysql` artifact then select "Executes query".
5. Put the variable name as `streamOutput` and then under the `RowType` field, click the dropdown menu, and click on
   "Add Type".
6. Put the name as `ProductReceived`.
7. Click on `+` to add a new field.
8. Put the name as `name` and select the type as `string` (`string` will be the default type). Do the same for the
   `unitType`, `currencyISO`, and `productId` fields.
9. Then click on "Save" button to save the type.
10. Under the `sqlQuery` field, paste the following query:

    ```text
    `SELECT name, unitType, currencyISO, productId FROM products WHERE processed = false`
    ```

11. Then click on "Save" button.
12. Then click on `+` button again to add a new node.
13. Under the right pane, click on "Declare Variable".
14. Then provide the name as `productsReceived`. From the dropdown menu under the `Type` field, select the type as
    `ProductReceived`. Then in "Type Helper" menu, click on the "Operators" tab and select "Convert type to array".
15. Click on the text box under the `Expression` field, and from the list of options appearing, select `check` clause,.
16. After that, put a space and then select `from clause`, then put a space and select `ProductReceived` from the list of options appearing.
17. Then type `productReceived` as the variable name.
18. Then select `in` from the list of options appearing, and then select `streamOutput` from the list of options
    appearing.
19. Then select `select` from the list of options, and then click on `productReceived`.
20. Finally click save button to save the variable.
21. Then click on `+` button again to add a new node.
22. Then from the right pane, under the "Control" section, click on "Foreach".
23. Under the variable name, put `productReceived`, and under the type, select `ProductReceived`.
24. Under the "Collection" field, select `productsReceived`.
25. Click on "Save" button to save the node.
26. Inside the `Foreach` node, click on `+` button to add a new node.
27. Select "Declare Variable" from the right pane.
28. Put the name as `product`.
29. Under the type, select "Add Type".
30. Provide the type name as `Product`.
31. Click on `+` to add fields similar to the `ProductReceived` type.
32. Add the following fields:
    - name: `Name`, type: `string`
    - name: `Product_Unit__c`, type: `string`
    - name: `CurrencyIsoCode`, type: `string`
33. Click on "Save" button to save the type.
34. Under the "Expression" field, click on "Map Data Inline" option.
35. In the data mapper, draw lines between the fields of `ProductReceived` and `Product` types.
    - `name` -> `Name`
    - `unitType` -> `Product_Unit__c`
    - `currencyISO` -> `CurrencyIsoCode`
36. Click on "Save" button to save the mapping.
37. Then add a new node inside the `Foreach` node.
38. Under the right pane, click on "salesforce" and select "Create Record".
39. Provide `_` as the variable name to ignore the variable.
40. Provide `"Product2"` as the object name (the `sObjectName` field).
41. Under the `record` field, click on the text box and select `product` from the list of options appearing.
42. Click on "Save" button to save the node.
43. Add a new node inside the `Foreach` node.
44. Under the right pane, click on "mysql" and select "Executes query".
45. Provide the variable name as `_` to ignore the variable.
46. Under the `sqlQuery` field, paste the following query:

    ```text
    `UPDATE products SET processed = true WHERE productId = ${productReceived.productId}`
    ```

47. Click on "Save" button to save the node.

Now the automation is complete.
