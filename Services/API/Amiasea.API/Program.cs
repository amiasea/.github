using Amiasea.API;
using Amiasea.API.Infrastructure; // The Sovereign Theater Engine
using Amiasea.Data.Service;
using Azure.Identity;
using Azure.Security.KeyVault.Keys.Cryptography;
using Octokit;
using Scalar.AspNetCore;
using Path = System.IO.Path;

var builder = WebApplication.CreateBuilder(args);

builder.AddAmiaseaTheater();

//builder.Services.AddScoped<IGitHubTokenProvider, GitHubTokenProvider>();

//builder.Services.AddScoped<IGitHubClient>(sp => 
//    new GitHubClient(new ProductHeaderValue("amiasea-api")));

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

// builder.Services.AddHttpClient<AirportService>(client =>
// {
//    var tfeBaseUrl = builder.Configuration["TerraformEnterprise:BaseUrl"] ?? "https://terraform.io";
//    client.BaseAddress = new Uri(tfeBaseUrl);

//    // Set up your standard enterprise communication headers here
//    client.DefaultRequestHeaders.Add("Accept", "application/vnd.api+json");

//    // You can pull your TFE token here if needed, or pass it dynamically in the service!
//    var tfeToken = builder.Configuration["TerraformEnterprise:Token"];
//    if (!string.IsNullOrEmpty(tfeToken))
//    {
//        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tfeToken);
//    }
// });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddOpenApi();

builder.Services.AddHttpContextAccessor();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.MapGet("/test-route", () => "Hello World").WithName("TestRoute");

app.MapEndpoints();

// Weave the Circuit Breaker and Signal Evaluators into the Woven Pipeline.
app.UseAmiaseaTheater();

app.Run();
