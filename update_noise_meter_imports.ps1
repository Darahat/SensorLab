# PowerShell script to update noise_meter imports after refactoring

$noiseMeterPath = "d:\Dream\Flutter App\SensorLab\lib\src\features\noise_meter"

# Get all Dart files in the noise_meter feature
$dartFiles = Get-ChildItem -Path $noiseMeterPath -Recurse -Filter "*.dart"

Write-Host "Updating imports in $($dartFiles.Count) Dart files..." -ForegroundColor Cyan

foreach ($file in $dartFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    $changed = $false
    
    # Update provider imports
    if ($content -match "presentation/providers/enhanced_noise_meter_provider") {
        $content = $content -replace "presentation/providers/enhanced_noise_meter_provider", "application/providers/enhanced_noise_meter_provider"
        $changed = $true
    }
    
    if ($content -match "presentation/providers/acoustic_reports_list_controller") {
        $content = $content -replace "presentation/providers/acoustic_reports_list_controller", "application/providers/acoustic_reports_list_controller"
        $changed = $true
    }
    
    if ($content -match "presentation/providers/custom_preset_provider") {
        $content = $content -replace "presentation/providers/custom_preset_provider", "application/providers/custom_preset_provider"
        $changed = $true
    }
    
    # Update state imports
    if ($content -match "presentation/state/enhanced_noise_data") {
        $content = $content -replace "presentation/state/enhanced_noise_data", "application/state/enhanced_noise_data"
        $changed = $true
    }
    
    if ($content -match "presentation/state/acoustic_reports_list_state") {
        $content = $content -replace "presentation/state/acoustic_reports_list_state", "application/state/acoustic_reports_list_state"
        $changed = $true
    }
    
    # Update service imports (only for non-application files)
    if ($file.DirectoryName -notlike "*\application\*") {
        if ($content -match "services/acoustic_report_service") {
            $content = $content -replace "services/acoustic_report_service", "application/services/acoustic_report_service"
            $changed = $true
        }
        
        if ($content -match "services/report_export_service") {
            $content = $content -replace "services/report_export_service", "application/services/report_export_service"
            $changed = $true
        }
        
        if ($content -match "services/monitoring_service") {
            $content = $content -replace "services/monitoring_service", "application/services/monitoring_service"
            $changed = $true
        }
        
        if ($content -match "services/custom_preset_service") {
            $content = $content -replace "services/custom_preset_service", "application/services/custom_preset_service"
            $changed = $true
        }
    }
    
    # Update relative service imports in data layer
    if ($file.DirectoryName -like "*\data\*" -and $content -match "\.\./\.\./services/") {
        $content = $content -replace "\.\./\.\./services/", "../application/services/"
        $changed = $true
    }
    
    # Update utils exports
    if ($file.Name -eq "utils_index.dart") {
        if ($content -match "\.\./presentation/state/enhanced_noise_data") {
            $content = $content -replace "\.\./presentation/state/enhanced_noise_data", "../application/state/enhanced_noise_data"
            $changed = $true
        }
    }
    
    # Update domain repository imports (they shouldn't import from presentation/state)
    if ($file.DirectoryName -like "*\domain\*" -and $content -match "presentation/state/enhanced_noise_data") {
        $content = $content -replace "presentation/state/enhanced_noise_data", "application/state/enhanced_noise_data"
        $changed = $true
    }
    
    if ($changed) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Updated: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Import update complete!" -ForegroundColor Green
Write-Host "Run flutter pub get and flutter analyze to verify." -ForegroundColor Yellow
