<div style="background-color: white; color: black; padding: 20px; font-weight: bold; border: 1px solid #ddd; border-radius: 8px;">

# Amiasea Enterprise Structure

### Global Assets
* <img src="icons/web_online_internet_global_earth_world_globe_icon_221254.svg" width="15" height="15" /> amiasea.com
* <img src="icons/github.svg" width="15" height="15" /> amiasea
* <img src="icons/hashicorp.svg" width="15" height="15" /> / <img src="icons/HashiCorp Terraform.svg" width="15" height="15" /> amiasea

---

<div style="background-color: white; border: 1px solid gray; padding: 15px; border-radius: 6px; margin-bottom: 10px; display: flex;">

<div style="flex: 1">

### (Azure - GitHub - HCP) Resources

* <img src="icons/github.svg" width="15" height="15" /> GitHub
    * <img src="icons/git-icon-logo-svgrepo-com.svg" width="15" height="15" /> amiasea/.github (Enterprise Base + Project Factory)
        * &nbsp;&nbsp;└─> <img src="icons/git-icon-logo-svgrepo-com.svg" width="15" height="15" /> amiasea/[project-name]
            * <img src="icons/HashiCorp Terraform.svg" width="15" height="15" /> HCL Config / HCP (Modules - Stacks - Deployments)
* <img src="icons/Microsoft_Azure.svg" width="15" height="15" /> Azure

    <div style="margin-left: 20px; margin-top: 10px;">
    <details open>
    <summary style="cursor: pointer;">
    <img src="icons/10002-icon-service-Subscriptions.svg" width="15" height="15" /> amiasea
    </summary>

    * ![Alt text](icons/10007-icon-service-Resource-Groups.svg) rg-amiasea
        * ![Alt text](icons/10064-icon-service-DNS-Zones.svg) amiasea.com
            * <img src="icons/dns-recordset.svg" width="15" height="15" /> [app-name][-env].amiasea.com <span style="color: red;">*</span>

    <details style="margin-left: 25px;">
    <summary style="cursor: pointer;">
    <img src="icons/10002-icon-service-Subscriptions.svg" width="15" height="15" /> amiasea-dev
    </summary>

    * ![Alt text](icons/10007-icon-service-Resource-Groups.svg) rg-amiasea-dev
        * ![Alt text](icons/10227-icon-service-Managed-Identities.svg) uami-amiasea-dev / ![Alt text](icons/10232-icon-service-App-Registrations.svg) app-oidc-amiasea-dev
        * ![Alt text](icons/10073-icon-service-Front-Door-and-CDN-Profiles.svg) front-door-dev
        * ![Alt text](icons/10228-icon-service-Azure-AD-B2C.svg) amiaseaciamdev.onmicrosoft.com <br> ( amiaseaciamdev.ciamlogin.com / auth.dev.amiasea.com )
            * ![Alt text](icons/10232-icon-service-App-Registrations.svg) app-[app-name]-dev <span style="color: red;">*</span>
        * ![Alt text](icons/02390-icon-service-Azure-SQL.svg) sql-dev
    </details>

    <details style="margin-left: 25px;">
    <summary style="cursor: pointer;">
    <img src="icons/10002-icon-service-Subscriptions.svg" width="15" height="15" /> amiasea-prod
    </summary>

    * ![Alt text](icons/10007-icon-service-Resource-Groups.svg) rg-amiasea-prod
        * ![Alt text](icons/10227-icon-service-Managed-Identities.svg) uami-amiasea-prod / ![Alt text](icons/10232-icon-service-App-Registrations.svg) app-oidc-amiasea-prod
        * ![Alt text](icons/10073-icon-service-Front-Door-and-CDN-Profiles.svg) front-door-prod
        * ![Alt text](icons/10228-icon-service-Azure-AD-B2C.svg) amiaseaciam.onmicrosoft.com <br> ( amiaseaciam.ciamlogin.com / auth.amiasea.com )
            * ![Alt text](icons/10232-icon-service-App-Registrations.svg) app-[app-name]-prod <span style="color: red;">*</span>
        * ![Alt text](icons/02390-icon-service-Azure-SQL.svg) sql-prod
    </details>

    </details>
    </div>

</div>

<div style="width: 1px; background-color:black; margin-left: 10px; margin-right: 10px;"></div>

<div style="flex: 0 0 40%;">

### Notes <span style="color: red;">*</span>

<div style="overflow-y: auto; height: 350px">

<i>It is not possible to logically group all of the resources with their corresponding ceremony and structural grouping.</i>

The OIDC SP is used to setup the Application Resources per environment including the app-[app-name]-[env] and the UAMI SP is used for inter-resource access.

The app-[app-name]-[env] is created for the corresponding Application Resources.

The [app-name][-env].amiasea.com DNS Zone Record is included in the Application Resources Terraform HCL.

</div>

</div>

</div>

<div style="background-color: white; border: 1px solid gray; padding: 15px; border-radius: 6px; margin-bottom: 10px; display: flex;">

<div style="flex: 1">

### Project Standard Resources
* ![Alt text](icons/10002-icon-service-Subscriptions.svg) amiasea-[env]
    * ![Alt text](icons/10007-icon-service-Resource-Groups.svg) rg-[app-name]-[env]
        * ![Alt text](icons/10130-icon-service-SQL-Database.svg) db-[app-name]-[env]

        Team
        GitHub Repo
        GitHub Project
        HCP Project
        HCP Workspace
        Resource Group

</div>

<div style="width: 1px; background-color:black; margin-left: 10px; margin-right: 10px;"></div>

<div style="flex: 0 0 40%;">

### Notes <span style="color: red;">*</span>

<div style="overflow-y: auto; height: 350px">

Amiasea has a small Workforce Tenant, but it is primarily a CIAM based External ID consumer based environment.

Products live within the Amiasea umbrella. CIAM provides consumer SSO across all products.

While the project level resources are in their own resource group by environment, they link to the Microsoft Graph API / Entra ID CIAM Tenant.

</div>

</div>

</div>
