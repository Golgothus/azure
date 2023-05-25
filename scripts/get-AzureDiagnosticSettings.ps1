# sets the subscription_id you're planning to enumerate
$subscriptionId = <Azure Subscription Id>

set-azcontext -subscription $subscriptionId

# creates an object containing a list of resource group names
$rg = (Get-AzResourceGroup).ResourceGroupName

foreach($r in $rg){
    # enumerates the resources in each resource group
    $resourceType = (Get-AzResource -ResourceGroupName $r).ResourceType
    $resourceId = (Get-AzResource -ResourceId $r).ResourceId

    foreach($item in $resourceId){
        # skips this resource type due to diagnostic settings not being applicable
        if($resourceType -eq "microsoft.network/networkwatches/flowlogs"){
            continue
        }
        # skips this resource type due to diagnostic settings not being applicable
        if($resourceType -eq "microsoft.insights/actiongroups"){
            continue
        }
        else{
            Get-AzDiagnosticSetting -ResourceId $item | Select-Object -Property Id,Name,WorkspaceId,EventHubAuthorizationRuleId,EventHubName -ErrorAction SilentlyContinue | Export-Csv -Path "~/diagnosticSettings.csv" -NoTypeInformation
        }
    }
}
