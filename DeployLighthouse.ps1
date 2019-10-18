$DeploymentName = "SetUpLighthouse"
$AzureRegion = "Southeast Asia"
$TemplateUri = "https://github.com/cloudysingh/AzureLighthouse/blob/master/delegatedResourceManagement.json"
$ParameterUri = "https://github.com/cloudysingh/AzureLighthouse/blob/master/delegatedResourceManagement.parameters.json"

New-AzDeployment -Name <deploymentName> `
                 -Location <AzureRegion> `
                 -TemplateUri <templateUri> `
                 -TemplateParameterUri <parameterUri> `
                 -Verbose
