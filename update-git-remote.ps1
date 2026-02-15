# Git Remote URL Updater
# Update dari username lama ke username baru

$oldUsername = "dimmmss23"
$newUsername = "agung-dimas"
$rootPath = "d:\laragon\www\"
$updatedCount = 0
$skippedCount = 0

Write-Host "Scanning projects in: $rootPath"
Write-Host ""

Get-ChildItem -Path $rootPath -Directory | ForEach-Object {
    $projectPath = $_.FullName
    $gitPath = Join-Path $projectPath ".git"
    
    if (Test-Path $gitPath) {
        $projectName = $_.Name
        Write-Host "Checking: $projectName"
        
        Push-Location $projectPath
        
        try {
            $currentRemote = git remote get-url origin 2>$null
            
            if ($currentRemote -match $oldUsername) {
                $newRemote = $currentRemote -replace $oldUsername, $newUsername
                
                Write-Host "  OLD: $currentRemote"
                Write-Host "  NEW: $newRemote"
                
                git remote set-url origin $newRemote
                Write-Host "  UPDATED!"
                $updatedCount++
            } else {
                Write-Host "  Already up-to-date"
                $skippedCount++
            }
        }
        catch {
            Write-Host "  ERROR: $_"
        }
        finally {
            Pop-Location
        }
        
        Write-Host ""
    }
}

Write-Host "========================================="
Write-Host "Summary:"
Write-Host "Updated:  $updatedCount projects"
Write-Host "Skipped:  $skippedCount projects"
Write-Host "========================================="
