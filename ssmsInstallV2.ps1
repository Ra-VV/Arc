# Define the download URL for SSMS 21
# This is the direct download link for SSMS 21.0
$ssmsUrl = "https://aka.ms/ssmsfullsetup"
# Note: The aka.ms link typically points to the latest version
# For SSMS 21 specifically, you may need to use the direct link

# Alternative: Use the specific version URL
# $ssmsUrl = "https://download.microsoft.com/download/7/5/7/757e9fb6-b8b6-4f5e-a1c6-8c4f8f8f8f8f/SSMS-Setup-ENU.exe"

# Define the local path where the installer will be saved
$downloadPath = "C:\Temp\SSMS-Setup-ENU.exe"

# Create the Temp directory if it doesn't exist
# This ensures we have a valid location to store the downloaded file
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" -Force | Out-Null
    Write-Host "Created directory: C:\Temp" -ForegroundColor Green
}

# Display progress to the user
Write-Host "Starting SSMS 21 download..." -ForegroundColor Cyan
Write-Host "Download URL: $ssmsUrl" -ForegroundColor Yellow
Write-Host "Destination: $downloadPath" -ForegroundColor Yellow

try {
    # Download SSMS using Invoke-WebRequest
    # We use -UseBasicParsing to avoid dependencies on Internet Explorer
    # -OutFile specifies where to save the downloaded file
    Invoke-WebRequest -Uri $ssmsUrl -OutFile $downloadPath -UseBasicParsing
    
    Write-Host "Download completed successfully!" -ForegroundColor Green
    Write-Host "File size: $([math]::Round((Get-Item $downloadPath).Length / 1MB, 2)) MB" -ForegroundColor Green
    
    # Optional: Install SSMS silently
    # Uncomment the following lines if you want to automatically install after download
    <#
    Write-Host "Starting SSMS installation..." -ForegroundColor Cyan
    Start-Process -FilePath $downloadPath -ArgumentList "/install /quiet /norestart" -Wait
    Write-Host "SSMS installation completed!" -ForegroundColor Green
    #>
    
} catch {
    # Handle any errors that occur during download
    Write-Host "Error downloading SSMS: $_" -ForegroundColor Red
    exit 1
}
