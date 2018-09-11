
Function Write-ToElasticsearch {
    <#
    .SYNOPIS
    Write PSCustomObject or Hashtable to Elasticsearch

    .EXAMPLE
    Get-Service | Select Name, Status, StartType | Write-JSONLog
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [PSCustomObject]$InputObject
    )

    Begin {
        $runTimeUTC = (Get-Date).ToUniversalTime()

        # Set Elasticsearch endpoint and index
        $esLogURL = "http://localhost:9200/log_audit_" + $runTimeUTC.ToString("yyyy.MM") + "/audit"
    }

    Process {
        foreach ($object in $InputObject) {
            Invoke-RestMethod -Method Post -Uri $esLogURL -ContentType "application/json" -Body (ConvertTo-Json -InputObject $object) -TimeoutSec 15 | Out-Null
        }
    }
}