$ErrorActionPreference = 'Stop'

$RepositoryName = 'Amiasea'
$RepositoryUri  = 'https://nuget.pkg.github.com/Amiasea/index.json'
$VaultName      = 'AmiaseaCodespace'
$SecretName     = 'GitHubPackages'

if ([string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)) {
    throw 'GITHUB_TOKEN is not available in this Codespace.'
}


Write-Host '1: Installing SecretManagement'
Install-PSResource `
    -Name Microsoft.PowerShell.SecretManagement `
    -Repository PSGallery `
    -TrustRepository
Write-Host '2: Installing SecretStore'
Install-PSResource `
    -Name Microsoft.PowerShell.SecretStore `
    -Repository PSGallery `
    -TrustRepository
Write-Host '3: Secret modules installed'
Write-Host '4: Checking vault'
Get-SecretVault -Name $VaultName -ErrorAction SilentlyContinue
Write-Host '5: Registering vault if necessary'

Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Microsoft.PowerShell.SecretStore

if (-not (Get-SecretVault -Name $VaultName -ErrorAction SilentlyContinue)) {
    Register-SecretVault `
        -Name $VaultName `
        -ModuleName Microsoft.PowerShell.SecretStore `
        -DefaultVault
}

Set-SecretStoreConfiguration `
    -Authentication None `
    -Interaction None `
    -Confirm:$false

$secureToken = ConvertTo-SecureString `
    $env:GITHUB_TOKEN `
    -AsPlainText `
    -Force

$credential = [PSCredential]::new(
    'CodespaceUser',
    $secureToken
)

Set-Secret `
    -Vault $VaultName `
    -Name $SecretName `
    -Secret $credential

$credentialInfo =
    [Microsoft.PowerShell.PSResourceGet.UtilClasses.PSCredentialInfo]::new(
        $VaultName,
        $SecretName
    )

$repository = Get-PSResourceRepository `
    -Name $RepositoryName `
    -ErrorAction SilentlyContinue

if ($repository) {
    Set-PSResourceRepository `
        -Name $RepositoryName `
        -Uri $RepositoryUri `
        -ApiVersion V3 `
        -CredentialInfo $credentialInfo `
        -Trusted
}
else {
    Register-PSResourceRepository `
        -Name $RepositoryName `
        -Uri $RepositoryUri `
        -ApiVersion V3 `
        -CredentialInfo $credentialInfo `
        -Trusted
}

Install-PSResource `
    -Name 'Amiasea.Proxies' `
    -Repository $RepositoryName `
    -Scope CurrentUser `
    -TrustRepository

Import-Module Amiasea.Proxies