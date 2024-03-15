# Azure Set Up

[[_TOC_]]
[[_TOSP_]]


## Prerequisites

- Azure Subscription
    * Tenant ID
    * Subscription ID
    * Resource Group name
- App Registration 
    * Client id
    * Client Secret
(https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app) 
- D365 Instance
    * Instance URL
    * Dataverse endpoint SQL DB name 
(https://learn.microsoft.com/en-us/power-apps/developer/data-platform/dataverse-sql-query) 
- Add above mentioned App Registration ID as Application User in D365 system and provide System Admin privileges to the user
(https://learn.microsoft.com/en-us/power-platform/admin/manage-application-users)
- Installing User to have Owner permissions on the Resource Group
- Power shell modules to be installed
    * **Az.Resources** (install-module Az.Resources)
    * **az.websites** (install-module Az.Websites)
    * **Az.ApplicationInsights** (install-module Az.ApplicationInsights)
    * **Az.KeyVault** (install-module Az.KeyVault)
    * **Az.RedisCache** (install-module Az.RedisCache)
    * **Az.CosmosDB** (install-module Az.CosmosDB)


## Deploy Azure Resources 

- Download the artifacts from Azure Deployment folder
    * **CreateResources.ps1** file
    * **publish.zip** file
</br>
- Open Windows Powershell in **Admin** mode

![image.png](/.attachments/image-d11ae93b-a962-42f4-8d2e-057d49c0058d.png)

- Execute the below command (if prompted, press A)
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

![image.png](/.attachments/image-4504e905-50b2-407a-a5a9-42d83b99fc6b.png)

- Execute the **CreateResources.ps1** file

![image.png](/.attachments/image-50639abd-2f0a-42f7-97b7-404c5be8b137.png)

**Note:** If you plan to change the Key Vault Name, make sure to update the same in **Microsoft.WWL.EBA.OLPAutomation.dll.config** file

![image.png](/.attachments/image-4a409cb0-8c41-4139-a3a0-485760b9aac4.png)

- On successful completion of PowerShell script file, 
   * Validate below components created in Azure Resource Group

![image.png](/.attachments/image-509c9e81-b87b-4e25-8e5d-4f9fd5ac9063.png)

   * Validate Web Job created in App service

![image.png](/.attachments/image-38ad441f-78b4-4778-b82b-0319a1e1625b.png)

<br/>
<br/>

## Configuration

**Navigate to Azure Cosmos Account => Data Explorer and manually create below items.**

![image.png](/.attachments/image-2876ff02-44a0-4dc8-96ef-59a3975bc21e.png)


```
{
    "d365Prefix": "d365",
    "configKeyVaultUrl": "KeyVaultUrl",
    "configEnvironmentName": "EnvironmentName",
    "partition": "Processor",
    "type": 5,
    "endpoint": "main",
    "container": "container",
    "lastReceive": "0001-01-01T00:00:00",
    "lastSuccess": "0001-01-01T00:00:00",
    "lastFailure": "0001-01-01T00:00:00",
    "d365SqlDBConnectionString": "Server={0},5558;Database={1};Persist Security Info=False;Connect Timeout=150;Encrypt=True;TrustServerCertificate=False",
    "isEnabled": "true",
    "id": "OLPAssetCatalogProcessor",
    "deleted": false,
    "locked": false,
    "sync": "2022-10-06T10:00:30.3033067Z",
    "retry": [],
    "_rid": "5+09AIhNCugBAAAAAAAAAA==",
    "_self": "dbs/5+09AA==/colls/5+09AIhNCug=/docs/5+09AIhNCugBAAAAAAAAAA==/",
    "_etag": "\"00001a07-0000-0100-0000-65a6d2b40000\"",
    "_attachments": "attachments/",
    "_ts": 1705431732
}

```

```
{
    "d365Prefix": "d365",
    "configKeyVaultUrl": "KeyVaultUrl",
    "configEnvironmentName": "EnvironmentName",
    "partition": "Processor",
    "type": 5,
    "endpoint": "main",
    "container": "container",
    "lastReceive": "0001-01-01T00:00:00",
    "lastSuccess": "0001-01-01T00:00:00",
    "lastFailure": "0001-01-01T00:00:00",
    "d365SqlDBConnectionString": "Server={0},5558;Database={1};Persist Security Info=False;Connect Timeout=150;Encrypt=True;TrustServerCertificate=False",
    "isEnabled": "true",
    "id": "OLPLPPDeduplicationProcessor",
    "deleted": false,
    "locked": false,
    "sync": "2023-01-09T17:55:28.8891436Z",
    "retry": [],
    "_rid": "5+09AIhNCugCAAAAAAAAAA==",
    "_self": "dbs/5+09AA==/colls/5+09AIhNCug=/docs/5+09AIhNCugCAAAAAAAAAA==/",
    "_etag": "\"00001907-0000-0100-0000-65a6d2a30000\"",
    "_attachments": "attachments/",
    "_ts": 1705431715
}

```


```
{
    "d365Prefix": "d365",
    "configKeyVaultUrl": "KeyVaultUrl",
    "configEnvironmentName": "EnvironmentName",
    "partition": "Processor",
    "type": 5,
    "endpoint": "main",
    "container": "container",
    "lastReceive": "0001-01-01T00:00:00",
    "lastSuccess": "0001-01-01T00:00:00",
    "lastFailure": "0001-01-01T00:00:00",
    "d365SqlDBConnectionString": "Server={0},5558;Database={1};Persist Security Info=False;Connect Timeout=150;Encrypt=True;TrustServerCertificate=False",
    "isEnabled": "true",
    "id": "OLPProgramParameterProcessor",
    "deleted": false,
    "locked": false,
    "sync": "2022-09-10T09:37:20.2057696Z",
    "retry": [],
    "_rid": "5+09AIhNCugDAAAAAAAAAA==",
    "_self": "dbs/5+09AA==/colls/5+09AIhNCug=/docs/5+09AIhNCugDAAAAAAAAAA==/",
    "_etag": "\"00001107-0000-0100-0000-65a6d2900000\"",
    "_attachments": "attachments/",
    "_ts": 1705431696
}

```


```
{
    "d365Prefix": "d365",
    "configKeyVaultUrl": "KeyVaultUrl",
    "configEnvironmentName": "EnvironmentName",
    "partition": "Processor",
    "type": 5,
    "endpoint": "main",
    "container": "container",
    "lastReceive": "0001-01-01T00:00:00",
    "lastSuccess": "0001-01-01T00:00:00",
    "lastFailure": "0001-01-01T00:00:00",
    "d365SqlDBConnectionString": "Server={0},5558;Database={1};Persist Security Info=False;Connect Timeout=150;Encrypt=True;TrustServerCertificate=False",
    "isEnabled": "true",
    "id": "OLPAPLDeduplicationProcessor",
    "deleted": false,
    "locked": false,
    "sync": "2023-01-09T17:55:28.8891436Z",
    "retry": [],
    "_rid": "5+09AIhNCugEAAAAAAAAAA==",
    "_self": "dbs/5+09AA==/colls/5+09AIhNCug=/docs/5+09AIhNCugEAAAAAAAAAA==/",
    "_etag": "\"00000f07-0000-0100-0000-65a6d27e0000\"",
    "_attachments": "attachments/",
    "_ts": 1705431678
}

```


```
{
    "d365Prefix": "d365",
    "configKeyVaultUrl": "KeyVaultUrl",
    "configEnvironmentName": "EnvironmentName",
    "partition": "Processor",
    "type": 5,
    "endpoint": "main",
    "container": "container",
    "lastReceive": "0001-01-01T00:00:00",
    "lastSuccess": "0001-01-01T00:00:00",
    "lastFailure": "0001-01-01T00:00:00",
    "d365SqlDBConnectionString": "Server={0},5558;Database={1};Persist Security Info=False;Connect Timeout=150;Encrypt=True;TrustServerCertificate=False",
    "isEnabled": "true",
    "id": "OLPLearnerProgramParameterProcessor",
    "deleted": false,
    "locked": false,
    "sync": "2022-09-07T06:45:58.6820033Z",
    "retry": [],
    "_rid": "5+09AIhNCugFAAAAAAAAAA==",
    "_self": "dbs/5+09AA==/colls/5+09AIhNCug=/docs/5+09AIhNCugFAAAAAAAAAA==/",
    "_etag": "\"00000907-0000-0100-0000-65a6d2370000\"",
    "_attachments": "attachments/",
    "_ts": 1705431607
}

```


```
{
    "d365Prefix": "d365",
    "configKeyVaultUrl": "KeyVaultUrl",
    "configEnvironmentName": "EnvironmentName",
    "partition": "Processor",
    "type": 5,
    "endpoint": "main",
    "container": "container",
    "lastReceive": "0001-01-01T00:00:00",
    "lastSuccess": "0001-01-01T00:00:00",
    "lastFailure": "0001-01-01T00:00:00",
    "d365SqlDBConnectionString": "Server={0},5558;Database={1};Persist Security Info=False;Connect Timeout=150;Encrypt=True;TrustServerCertificate=False",
    "isEnabled": "true",
    "id": "OLPAPLPreserveFlagsProcessor",
    "deleted": false,
    "locked": false,
    "sync": "2023-01-09T17:55:28.8891436Z",
    "retry": [],
    "_rid": "5+09AIhNCugGAAAAAAAAAA==",
    "_self": "dbs/5+09AA==/colls/5+09AIhNCug=/docs/5+09AIhNCugGAAAAAAAAAA==/",
    "_etag": "\"00000c07-0000-0100-0000-65a6d24e0000\"",
    "_attachments": "attachments/",
    "_ts": 1705431630
}

```

```
{
    "d365Prefix": "d365",
    "configKeyVaultUrl": "KeyVaultUrl",
    "configEnvironmentName": "EnvironmentName",
    "partition": "Processor",
    "type": 5,
    "endpoint": "main",
    "container": "container",
    "lastReceive": "0001-01-01T00:00:00",
    "lastSuccess": "0001-01-01T00:00:00",
    "lastFailure": "0001-01-01T00:00:00",
    "d365SqlDBConnectionString": "Server={0},5558;Database={1};Persist Security Info=False;Connect Timeout=150;Encrypt=True;TrustServerCertificate=False",
    "isEnabled": "true",
    "id": "OLPAPLDeleteDuplicationProcessor",
    "deleted": false,
    "locked": false,
    "sync": "2023-01-09T17:55:28.8891436Z",
    "retry": [],
    "_rid": "5+09AIhNCugHAAAAAAAAAA==",
    "_self": "dbs/5+09AA==/colls/5+09AIhNCug=/docs/5+09AIhNCugHAAAAAAAAAA==/",
    "_etag": "\"00000e07-0000-0100-0000-65a6d2690000\"",
    "_attachments": "attachments/",
    "_ts": 1705431657
}

```