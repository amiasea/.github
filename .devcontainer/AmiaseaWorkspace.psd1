@{
    RootModule        = 'AmiaseaWorkspace.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '00000000-0000-0000-0000-000000000000'
    Author            = 'Amiasea'
    Description       = 'Amiasea workspace discovery and provisioning commands.'
    FunctionsToExport = @(
        'Discover-AmiaseaWorkspace'
        'Provision-AmiaseaWorkspace'
    )
}