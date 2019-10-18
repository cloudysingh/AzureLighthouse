$DeploymentName = "SetUpLighthouse"
$AzureRegion = "Southeast Asia"
$TemplateUri = "https://raw.githubusercontent.com/cloudysingh/AzureLighthouse/master/delegatedResourceManagement.json"
$ParameterUri = "https://raw.githubusercontent.com/cloudysingh/AzureLighthouse/master/delegatedResourceManagement.parameters.json"

New-AzDeployment -Name $DeploymentName `
                 -Location $AzureRegion `
                 -TemplateUri $TemplateUri `
                 -TemplateParameterUri $ParameterUri `
                 -Verbose
