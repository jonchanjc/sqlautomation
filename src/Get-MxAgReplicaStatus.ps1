#Requires -Version 5
#Requires -Modules Sqlserver

function Get-MxAgReplicaStatus
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $ComputerName
    )

    Process
    {
        $sql=Get-SqlInstance -ServerInstance $ComputerName
        ($sql.AvailabilityGroups).AvailabilityReplicas | Where-Object {$_.Role -ne "UNKNOWN"} | Select-Object @{N='AvailabilityGroup';E={$_.Parent}}, @{N='ReplicaName';E={$_.Name}}, Role, RollupSynchronizationstate, FailoverMode, AvailabilityMode 
    }
}