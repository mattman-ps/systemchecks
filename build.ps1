#Requires -Version 7.4

<#
.SYNOPSIS
    Build script for systemchecks module
.DESCRIPTION
    Combines source files into a distributable module without external dependencies
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# Define paths
$ProjectRoot = $PSScriptRoot
$SourcePath = Join-Path $ProjectRoot 'src'
$DistPath = Join-Path $ProjectRoot 'dist' 'systemchecks'
$PublicPath = Join-Path $SourcePath 'public'
$PrivatePath = Join-Path $SourcePath 'private'
$ResourcesPath = Join-Path $SourcePath 'resources'

Write-Host "Building systemchecks module..." -ForegroundColor Cyan

# Clean and create dist directory
if (Test-Path $DistPath) {
    Remove-Item $DistPath -Recurse -Force
}
New-Item -Path $DistPath -ItemType Directory -Force | Out-Null

# Get all PowerShell files
$publicFiles = Get-ChildItem -Path $PublicPath -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue
$privateFiles = Get-ChildItem -Path $PrivatePath -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue

# Build the module file
$moduleContent = @()

# Add private functions
if ($privateFiles) {
    foreach ($file in $privateFiles) {
        Write-Host "  Adding private function: $($file.BaseName)" -ForegroundColor Gray
        $moduleContent += Get-Content $file.FullName -Raw
        $moduleContent += "`n"
    }
}

# Add public functions
if ($publicFiles) {
    foreach ($file in $publicFiles) {
        Write-Host "  Adding public function: $($file.BaseName)" -ForegroundColor Gray
        $moduleContent += Get-Content $file.FullName -Raw
        $moduleContent += "`n"
    }
}

# Write the combined module file
$moduleFile = Join-Path $DistPath 'systemchecks.psm1'
$moduleContent -join "`n" | Set-Content -Path $moduleFile -Encoding utf8

# Copy module manifest
$manifestSource = Join-Path $ProjectRoot 'systemchecks.psd1'
$manifestDest = Join-Path $DistPath 'systemchecks.psd1'
if (Test-Path $manifestSource) {
    Copy-Item -Path $manifestSource -Destination $manifestDest -Force
    Write-Host "  Copied module manifest" -ForegroundColor Gray
}

# Copy resources if they exist
if (Test-Path $ResourcesPath) {
    $resourcesDest = Join-Path $DistPath 'resources'
    Copy-Item -Path $ResourcesPath -Destination $resourcesDest -Recurse -Force
    Write-Host "  Copied resources" -ForegroundColor Gray
}

Write-Host "Build complete: $DistPath" -ForegroundColor Green
