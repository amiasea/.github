$repositoryName = 'Amiasea'
$repositoryUri = 'https://nuget.pkg.github.com/Amiasea/index.json'

if (-not (Get-PSResourceRepository -Name $repositoryName -ErrorAction SilentlyContinue)) {
    Register-PSResourceRepository `
        -Name $repositoryName `
        -Uri $repositoryUri
}

Install-PSResource `
    -Name Amiasea.Proxies `
    -Repository $repositoryName `
    -Scope CurrentUser `
    -TrustRepository

Import-Module Amiasea.Proxies