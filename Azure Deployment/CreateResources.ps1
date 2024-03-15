$webJobZipPath = "publish_updated.zip"

$fileExist = Test-Path $webJobZipPath

if ($fileExist)
{
	Write-Host "Starting execution."
}
else
{
Write-Host "$webJobZipPath Deployment file does not exist. Stopping execution."
return
}

# Inputs
$tenantId = Read-Host -Prompt "Please provide your Azure Tenant ID"
$subscriptionId = Read-Host -Prompt "Please provide your Azure Subscription ID"
$resourceGroupName = Read-Host -Prompt "Please provide your Resource Group name"
$suffix = Read-Host -Prompt "Please provide suffix for your apps name. e.g. dev | uat | prod: "
$D365Url = Read-Host -Prompt "D365 URl: "
$D365OrgName = Read-Host -Prompt "D365 Unique Organization Name: "
$D365ClientId = Read-Host -Prompt "D365 Client Id: "
$D365ClientSecret = Read-Host -Prompt "D365 Client Secret: "

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

#Login to Azure account
Connect-AzAccount

# Get the Azure subscription based on the subscription ID
$subscription = Get-AzSubscription | Where-Object { $_.Id -eq $subscriptionId -and $_.TenantId -eq $tenantId }

# Check if the subscription is available
if ($subscription)
{
$subscriptionName = $subscription.Name
$subscriptionId = $subscription.Id
$tenantId = $subscription.TenantId
Write-Host "Subscription found. Subscription Name:" $subscription.Name
}
else
{
Write-Host "Subscription with ID '$subscriptionId' and Tenant ID '$tenantId' not found"
# Stop the script
return
}

# Azure resource names
$EmpOnboardingAppServicePlan = "asp-employeeonboardingapp"+ '-' + $suffix
$EmpOnboardingAppWebApp   = "app-employeeonboardingapp"+ '-' + $suffix
$EmpOnboardingAppInsights = "appi-employeeonboardingapp"+ '-' + $suffix
$EmpOnboardingAppKeyVault = "kv-emponboard-app"
$EmpOnboardingAppRedisCache = "rdscahe-employeeonboardingapp"+ '-' + $suffix
$EmpOnboardingAppSKU = "Standard"
$EmpOnboardingAppCosmosDBAccountName = "csms-employeeonboardingapp"+ '-' + $suffix
$EmpOnboardingAppCosmosDBName = "main"
$EmpOnboardingAppCosmosContainerName = "agents"
$EmpOnboardingAppCosmosPartitionKeyPath = "/partition"
$EmpOnboardingAppCosmosPartitionKeyKind = "Hash"


#set Subscription for resource creation
Set-AzContext  -SubscriptionId $subscriptionId 

# Create new resource group if not exists.
$rgAvailable = Get-AzResourceGroup -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue

if(!$rgAvailable){
Write-Host "Resource Group not found. Please provide a valid Resource Group"
# Stop the script
return
}
else
{
$resourceGroupName = $rgAvailable.ResourceGroupName
write-Host "Resource Group found"
$location = $rgAvailable.Location
}

Write-Host "location - " $location

# Create App Service Plan if not exists
$EmployeeOnboardingAppServicePlan = Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppServicePlan

if(!$EmployeeOnboardingAppServicePlan)
{
Write-Host "Creating App Service Plan: " $EmpOnboardingAppServicePlan
New-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppServicePlan -Location $location -Tier Free
}
$EmployeeOnboardingAppServicePlan = Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppServicePlan


# Create new WebApp for WebJobs Application if not exists
$EmployeeOnboardingAppWebApp = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppWebApp -ErrorAction SilentlyContinue

if(!$EmployeeOnboardingAppWebApp -And $EmployeeOnboardingAppServicePlan)
{
Write-Host "Creating App Service: " $EmpOnboardingAppWebApp
New-AzWebApp -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppWebApp -Location $location -AppServicePlan $EmpOnboardingAppServicePlan
}

# Create new App Insights if not exists
$EmployeeOnboardingAppInsights = Get-AzApplicationInsights -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppInsights -ErrorAction SilentlyContinue

if(!$EmployeeOnboardingAppInsights)
{
Write-Host "Creating App Insights: " $EmpOnboardingAppInsights
New-AzApplicationInsights -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppInsights -Location $location -ApplicationType web
}

# Create new Key Vault if not exists
$EmployeeOnboardingAppKeyVault = Get-AzKeyVault -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppKeyVault -ErrorAction SilentlyContinue

if(!$EmployeeOnboardingAppKeyVault)
{
Write-Host "Creating Key Vault: " $EmpOnboardingAppKeyVault
New-AzKeyVault -ResourceGroupName $resourceGroupName -VaultName $EmpOnboardingAppKeyVault -Location $location
}

# Create the Redis Cache
New-AzRedisCache -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppRedisCache -Location $location -Sku $EmpOnboardingAppSKU

$redisPrimaryKey = (Get-AzRedisCacheKey -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppRedisCache).PrimaryKey
$redisConnectionString = $EmpOnboardingAppRedisCache+ ".redis.cache.windows.net:6380,password="+$redisPrimaryKey+",ssl=True,abortConnect=False"

# Create the Cosmos DB account
New-AzCosmosDBAccount -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppCosmosDBAccountName -Location $location -ApiKind 'Sql'

# Create a new Cosmos DB database
$database = New-AzCosmosDBSqlDatabase -ResourceGroupName $resourceGroupName -AccountName $EmpOnboardingAppCosmosDBAccountName -Name $EmpOnboardingAppCosmosDBName

# Create a new Cosmos DB container within the database
$container = New-AzCosmosDBSqlContainer -ResourceGroupName $resourceGroupName `
                                        -AccountName $EmpOnboardingAppCosmosDBAccountName `
                                        -DatabaseName $EmpOnboardingAppCosmosDBName `
                                        -Name $EmpOnboardingAppCosmosContainerName `
                                        -PartitionKeyPath $EmpOnboardingAppCosmosPartitionKeyPath `
                                        -PartitionKeyKind $EmpOnboardingAppCosmosPartitionKeyKind `
                                        -Throughput 400  # Adjust the throughput value as needed

$cosmosConnectionString = (Get-AzCosmosDBAccountKey -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppCosmosDBAccountName -Type "ConnectionStrings").'Primary SQL Connection String'

$appInsightsIntrumentationkey = (Get-AzApplicationInsights -ResourceGroupName $resourceGroupName -Name $EmpOnboardingAppInsights).InstrumentationKey

# Add secrets to the Key Vault
$secrets = @{
"cacheredisconfig-prod" = $redisConnectionString
"ebainsightskey-prod" = $appInsightsIntrumentationkey
"prosipconnectionstring-prod" = $cosmosConnectionString
"d365sqlserver-prod" = $D365Url.Replace("https://","").Replace("/","")
"d365sqldb-prod" = $D365OrgName
"d365tenantid-prod" = $tenantId
"olpd365sqlresourceid-prod" = $D365Url
"olpd365sqlclientid-prod" = $D365ClientId
"olpd365sqlclientsecret-prod" = $D365ClientSecret
"surveyd365url-prod" = $D365Url
"surveyd365tenantid-prod" = $tenantId
"surveyd365clientid-prod" = $D365ClientId
"surveyd365clientsecret-prod" = $D365ClientSecret
}

foreach ($secretName in $secrets.Keys) {
    $secretValue = $secrets[$secretName]
    $secret = ConvertTo-SecureString -String $secretValue -AsPlainText -Force
    Set-AzKeyVaultSecret -VaultName $EmpOnboardingAppKeyVault -Name $secretName -SecretValue $secret
}


##########################################################

$EmpOnboardingWebJobName = 'wj-employeeonboardingapp'
$jobType = "triggeredwebjobs"


# Assign the "Contributor" role to the App Registration on the Web App
New-AzRoleAssignment -ApplicationId $D365ClientId -RoleDefinitionName Contributor -Scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$EmpOnboardingAppWebApp"

Write-Host "Contributor role assigned"

# Acquire Azure AD token using Client Credentials Grant Flow
$tokenEndpoint = "https://login.microsoftonline.com/$tenantId/oauth2/token"
$body = @{
    grant_type    = "client_credentials"
    client_id     = $D365ClientId
    client_secret = $D365ClientSecret
    resource      = "https://management.azure.com/"
}
$tokenResponse = Invoke-RestMethod -Uri $tokenEndpoint -Method Post -Body $body

# Construct the authorization header using the access token
$accessToken = $tokenResponse.access_token
Write-Host "Bearer Token aquired"

$headers = @{
    'Content-Disposition'='attachment; filename=OLPProducatization.zip' 
    'Authorization' = "Bearer $accessToken"
}

# Set the environment variables for Azure AD service principal
$env:AZURE_TENANT_ID = $tenantId
$env:AZURE_CLIENT_ID = $D365ClientId
$env:AZURE_CLIENT_SECRET = $D365ClientSecret

# API URL for deploying WebJob
$webAppURL = 'https://'+$EmpOnboardingAppWebApp+'.scm.azurewebsites.net/api/'+$jobType+'/'+$EmpOnboardingWebJobName+''

# Deploy WebJob
$response = Invoke-RestMethod -Uri $webAppURL -Headers $headers -Method Put -InFile $webJobZipPath -ContentType "application/zip"

Write-Host "WebJob deployment status:" $response


Write-Host "Enabling managed identity on web app"
Set-AzWebApp -AssignIdentity $true -Name $EmpOnboardingAppWebApp -ResourceGroupName $resourceGroupName

$appSeriveObjectId = (Get-AzWebApp -Name $EmpOnboardingAppWebApp -ResourceGroupName $resourceGroupName).Identity.PrincipalId

Write-Host "Assigning permission on Key Vault for app service"
New-AzRoleAssignment -ObjectId $appSeriveObjectId -RoleDefinitionName "Key Vault Secrets User" -Scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.KeyVault/vaults/$EmpOnboardingAppKeyVault"

Set-AzKeyVaultAccessPolicy -VaultName $EmpOnboardingAppKeyVault -ObjectId $appSeriveObjectId -PermissionsToSecrets Get,Set,List

Write-Host "Script Completed."