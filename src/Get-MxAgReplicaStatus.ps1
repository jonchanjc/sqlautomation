#Requires -Version 5
#Requires -Modules Sqlserver

function Get-MxAgReplicaStatus
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        [string] $ComputerName,
        [Parameter(Mandatory=$false)]
        [pscredential] $Credential
    )

    Process
    {
        if ($Credential) {
            $sql=Get-SqlInstance -ServerInstance $ComputerName -Credential $Credential
        }
        else {
            $sql=Get-SqlInstance -ServerInstance $ComputerName
        }
        
        ($sql.AvailabilityGroups).AvailabilityReplicas | Where-Object {$_.Role -ne "UNKNOWN" -and $_.OperationalState -ne "Unknown"} | Select-Object @{N='AvailabilityGroup';E={$_.Parent}}, @{N='ReplicaName';E={$_.Name}}, Role, OperationalState, RollupSynchronizationstate, FailoverMode, AvailabilityMode 
    }

<#
.SYNOPSIS

Return AG replica status

.DESCRIPTION

List all the availability groups, replica names and their corresponding roles, failover mode and synchronization status on any AG replica.
This eliminates the bottleneck from waiting for DBA to provide the information.

.PARAMETER ComputerName
The server name of the SQL Server replica

.EXAMPLE
Get-MxAgReplicaStatus -ComputerName SQL01
Getting status for a single computer

.EXAMPLE
"SQL01","SQL02", "SQL03" | Get-MxAgReplicaStatus
Piping multiple servernames to the cmdlet
#>

}