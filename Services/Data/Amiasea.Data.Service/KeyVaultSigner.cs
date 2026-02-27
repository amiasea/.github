using System;
using System.Collections.Generic;
using System.Text;
using Azure.Security.KeyVault.Keys.Cryptography;

namespace Amiasea.Data.Service;

public class KeyVaultSigner(CryptographyClient client) : ISovereignSigner
{
    public async Task<byte[]> SignDataAsync(byte[] data) =>
        (await client.SignDataAsync(SignatureAlgorithm.RS256, data)).Signature;
}