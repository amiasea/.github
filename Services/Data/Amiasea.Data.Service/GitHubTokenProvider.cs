using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Extensions.Configuration;

namespace Amiasea.Data.Service;

public class GitHubTokenProvider(IConfiguration config, ISovereignSigner signer) : IGitHubTokenProvider
{
    public async Task<string> GetTokenAsync()
    {
        // 1. Get the Identity 'Law' from config
        var appId = config["GitHub:AppId"];
        var installationId = config["GitHub:InstallationId"];

        if (string.IsNullOrEmpty(appId) || string.IsNullOrEmpty(installationId))
            throw new Exception("GitHub configuration is missing from the Substrate (appsettings).");

        // 2. ASSERTION: Mint the 10-minute JWT using the Signer (HSM or PEM)
        var jwt = await GitHubJwtFactory.CreateAsync(appId, signer);

        // 3. HANDSHAKE: Exchange the JWT for a 1-hour Installation Token
        return await GitHubTokenExchanger.ExchangeAsync(jwt, installationId);
    }
}