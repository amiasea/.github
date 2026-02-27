using Amiasea.API;
using Amiasea.API.Infrastructure; // The Sovereign Theater Engine
using Amiasea.Aviator.Data.Service;
using Amiasea.Data.Service;
using Azure.Identity;
using Azure.Security.KeyVault.Keys.Cryptography;
using Octokit;
using Scalar.AspNetCore;
using Path = System.IO.Path;

var builder = WebApplication.CreateBuilder(args);

// 1. THE GENESIS ACT: Initialize the Sovereign Kernel
// Weave the Registry of Truth into the Substrate.
builder.AddAmiaseaTheater();

builder.Services.AddScoped<IGitHubTokenProvider, GitHubTokenProvider>();

builder.Services.AddScoped<IGitHubClient>(sp => 
    new GitHubClient(new ProductHeaderValue("amiasea-api")));

if (builder.Environment.IsDevelopment())
{
    string devKeyPath = Path.Combine(Directory.GetCurrentDirectory(), "github_private_key.pem");

    if (File.Exists(devKeyPath))
    {
        builder.Services.AddSingleton<ISovereignSigner>(new LocalFileSigner(devKeyPath));
    }
    else
    {
        throw new FileNotFoundException(".pem file is missing from disk.");
    }
}
else
{
    var vaultUri = builder.Configuration["KeyVault:VaultUri"];
    var keyName = builder.Configuration["KeyVault:KeyName"];

    var keyId = $"{vaultUri.TrimEnd('/')}/keys/{keyName}";

    // Use the "Location-based" hardware assertion for the Cloud    
    var cryptoClient = new CryptographyClient(
        new Uri(vaultUri),
        new DefaultAzureCredential());

    builder.Services.AddSingleton(cryptoClient);
    builder.Services.AddSingleton<ISovereignSigner, KeyVaultSigner>();
}

// 3. THE ARCHITECTURAL SERVICES
// No DB here. We are using the 'Sovereign Ledger' of the State & Git.
builder.Services.AddScoped<AirportService>(); 
builder.Services.AddOpenApi();

var app = builder.Build();

// 4. THE LAUNCH: Trigger the Wolverine Loom
// Weave the Circuit Breaker and Signal Evaluators into the Woven Pipeline.
app.UseAmiaseaTheater();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.MapEndpoints();

app.Run();
