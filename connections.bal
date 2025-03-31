import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerinax/salesforce;

final mysql:Client mysql = check new (host, user, password, database, port);

final salesforce:Client salesforce = check new ({baseUrl: salesforceBaseUrl, auth: {token: salesforceAccessToken}});
