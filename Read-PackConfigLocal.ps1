<# 
----------------------------------------------------------------------------

Created:      Paul Bullock
Copyright (c) 2019 CaPa Creative Ltd
Date:         06/01/2020
Disclaimer:   

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

.Synopsis

.Example

.Notes

Useful reference: 
      List any useful references

 ----------------------------------------------------------------------------
#>

[CmdletBinding()]
param (
    $BasePath = "docs\intranet\v3",
    $MetadataFile = "metadata.json",
    $AssetsFile = "assets.json"
)
begin{

  Write-Host @"
  _________      ________            _________                  __________                  ______ ______________
  __  ____/_____ ___  __ \_____ _    __  ____/_________________ __  /___(_)__   ______      ___  / __  /______  /
  _  /    _  __ `/_  /_/ /  __ `/    _  /    __  ___/  _ \  __ `/  __/_  /__ | / /  _ \     __  /  _  __/  __  / 
  / /___  / /_/ /_  ____// /_/ /     / /___  _  /   /  __/ /_/ // /_ _  / __ |/ //  __/     _  /___/ /_ / /_/ /  
  \____/  \__,_/ /_/     \__,_/      \____/  /_/    \___/\__,_/ \__/ /_/  _____/ \___/      /_____/\__/ \__,_/   
                                                                                                                 
"@

}
process {

    Write-Host "Getting metadata.json from local files"
    $fullMetadataPath = "$(Get-Location)\$BasePath\$($MetadataFile)"
    $fullAssetsPath = "$(Get-Location)\$BasePath\$($AssetsFile)"
    $metadata = Get-Content -Path $fullMetadataPath -Raw | ConvertFrom-Json
    $assets = Get-Content -Path $fullAssetsPath -Raw | ConvertFrom-Json

    
    #region Metadata
    
    $metadataContent = ""

    $metadataContent = $metadataContent + "# Reference Ids for the Learning Portal Content Pack Creation `n`n"
    $metadataContent = $metadataContent + "> Note: This is generated from a PowerShell script, do not update`n "
    $metadataContent = $metadataContent + "> Generated on: $([System.DateTime]::Now)`n"
    $metadataContent = $metadataContent + "## List of Technologies and Subjects `n`n"
    
    $metadataContent = $metadataContent + "`n| Id | Name | Subjects | `n"
    $metadataContent = $metadataContent + "|------|------|---------| `n"
    $metadata.Technologies | Foreach-Object {

        $metadataContent = $metadataContent + "| $($_.Id) | $($_.Name) | "
        if($_.Subjects){
            $metadataContent = $metadataContent + "<table><thead><tr><th>Id</th><th>Name</th></tr></thead><tbody>"
            $_.Subjects | ForEach-Object {
                $metadataContent = $metadataContent + "<tr><td>" + $_.Id + "</td><td>" + $_.Name + "</td></tr>"
            }
            $metadataContent = $metadataContent + "</tbody></table> | "
        }
        $metadataContent = $metadataContent + "`n"
    }
    
    $metadataContent = $metadataContent + "`n`n## List of Categories and Sub Categories`n`n"
    
    $metadataContent = $metadataContent + "`n| Id | Name | Sub Categories | `n"
    $metadataContent = $metadataContent + "|------|------|---------| `n"
    $metadata.Categories | Foreach-Object {

        $metadataContent = $metadataContent + "| $($_.Id) | $($_.Name) | "
        
        if($_.SubCategories){
            $metadataContent = $metadataContent + "<table><thead><tr><th>Id</th><th>Name</th></tr></thead><tbody>"
            $_.SubCategories | ForEach-Object {
                $metadataContent = $metadataContent + "<tr><td>" + $_.Id + "</td><td>" + $_.Name + "</td></tr>"
            }
            $metadataContent = $metadataContent + "</tbody></table> | "
        }
        $metadataContent = $metadataContent + "`n"
    }
    
    $metadataContent = $metadataContent + "`n`n## List of Audiences`n`n"
    
    $metadataContent = $metadataContent + "| Id | Name |`n"
    $metadataContent = $metadataContent + "|----|------|`n"
    
    $metadata.Audiences | Foreach-Object {
        $metadataContent = $metadataContent + "| " +  $_.Id + " | " + $_.Name + " | `n"
    }

    $metadataContent = $metadataContent + "`n`n## List of Levels`n`n"
    $metadataContent = $metadataContent + "| Id | Name |`n"
    $metadataContent = $metadataContent + "|----|------|`n"
    $metadata.Levels | Foreach-Object {
        $metadataContent = $metadataContent + "| " + $_.Id + " | " + $_.Name + " | `n"
    }

    $metadataContent = $metadataContent + "`n`n## List of Status Tag`n`n"
    $metadataContent = $metadataContent + "| Id | Name |`n"
    $metadataContent = $metadataContent + "|----|------|`n"
    $metadata.StatusTag | Foreach-Object {
        $metadataContent = $metadataContent + "| " + $_.Id + " | " + $_.Name + " |`n"
    }

    $metadataContent
    $metadataContent | Out-File -FilePath "$(Get-Location)/learning-portal-metadata-reference.md" -Force -Encoding utf8

    #endregion

    #region Assets

    $assetsContent = ""

    $assetsContent = $assetsContent + "# Reference for the Learning Portal Content Pack Creation `n`n"
    $assetsContent = $assetsContent + "> Note: This is generated from a PowerShell script, do not update`n "
    $assetsContent = $assetsContent + "> Generated on: $([System.DateTime]::Now)`n"

    $assetsContent = $assetsContent + "`n`n## List of Audiences`n`n"
    
    $assetsContent = $assetsContent + "| Id | Title | Description |`n"
    $assetsContent = $assetsContent + "|----|-------|-------------|`n"
    
    $assets | Foreach-Object {
        $assetsContent = $assetsContent + "| " +  $_.Id + " | " + $_.Title + " | "+ $_.Description +" | `n"
    }

    $assetsContent
    $assetsContent | Out-File -FilePath "$(Get-Location)/learning-portal-asset-reference.md" -Force -Encoding utf8

    #endregion

}
