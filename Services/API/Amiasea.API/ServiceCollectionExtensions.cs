using Microsoft.Azure.Cosmos;

namespace Amiasea.API;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddAmiaseaIdentity(this IServiceCollection services, string connectionString)
    {
        var client = new CosmosClient(connectionString, new CosmosClientOptions
        {
            SerializerOptions = new CosmosSerializationOptions { PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase },
            ConnectionMode = ConnectionMode.Direct
        });

        services.AddSingleton(client);
        return services;
    }
}