$ErrorActionPreference = 'Stop'

$RepositoryName = 'Amiasea'
$RepositoryUri  = 'https://nuget.pkg.github.com/Amiasea/index.json'
$VaultName      = 'AmiaseaCodespace'
$SecretName     = 'GitHubPackages'

if ([string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)) {
throw 'GITHUB_TOKEN is not available in this Codespace.'
}

Write-Host '1: Installing SecretManagement'

Install-PSResource `    -Name Microsoft.PowerShell.SecretManagement`
-Repository PSGallery `    -TrustRepository`
-Scope CurrentUser

Write-Host '2: Installing SecretStore'

Install-PSResource `    -Name Microsoft.PowerShell.SecretStore`
-Repository PSGallery `    -TrustRepository`
-Scope CurrentUser

Write-Host '3: Secret modules installed'

Import-Module Microsoft.PowerShell.SecretManagement -Force
Import-Module Microsoft.PowerShell.SecretStore -Force

Write-Host '4: Configuring SecretStore'

Set-SecretStoreConfiguration `    -Authentication None`
-Interaction None `
-Confirm:$false

Write-Host '5: Checking vault'

$vault = Get-SecretVault `    -Name $VaultName`
-ErrorAction SilentlyContinue

if (-not $vault) {
Write-Host '6: Registering vault'

```
Register-SecretVault `
    -Name $VaultName `
    -ModuleName Microsoft.PowerShell.SecretStore `
    -DefaultVault
```

}
else {
Write-Host '6: Vault already registered'
}

Write-Host '7: Creating GitHub Packages credential'

$secureToken = ConvertTo-SecureString `    $env:GITHUB_TOKEN`
-AsPlainText `
-Force

$credential = [PSCredential]::new(
'x-access-token',
$secureToken
)

Set-Secret `    -Vault $VaultName`
-Name $SecretName `    -Secret $credential`
-Force

Write-Host '8: Creating PSResourceGet credential info'

$credentialInfo =
[Microsoft.PowerShell.PSResourceGet.UtilClasses.PSCredentialInfo]::new(
$VaultName,
$SecretName
)

Write-Host '9: Configuring Amiasea repository'

$repository = Get-PSResourceRepository `    -Name $RepositoryName`
-ErrorAction SilentlyContinue

if ($repository) {
Set-PSResourceRepository `        -Name $RepositoryName`
-Uri $RepositoryUri `        -ApiVersion V3`
-CredentialInfo $credentialInfo `        -Trusted
}
else {
    Register-PSResourceRepository`
-Name $RepositoryName `        -Uri $RepositoryUri`
-ApiVersion V3 `        -CredentialInfo $credentialInfo`
-Trusted
}

Write-Host '10: Installing Amiasea.Proxies'

Install-PSResource `    -Name 'Amiasea.Proxies'`
-Repository $RepositoryName `    -Scope CurrentUser`
-TrustRepository

Write-Host '11: Importing Amiasea.Proxies'

Import-Module Amiasea.Proxies -Force

Write-Host '12: Done'
