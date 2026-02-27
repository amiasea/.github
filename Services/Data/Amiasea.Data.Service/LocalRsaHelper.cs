using System.Security.Cryptography;
using System.Text;

namespace Amiasea.Data.Service;
public static class LocalRsaHelper
{
    public static byte[] Sign(string pemPath, byte[] data)
    {
        // 1. Read the "Knowledge-based" Fact from your disk
        string pemContent = File.ReadAllText(pemPath);

        using var rsa = RSA.Create();

        // 2. Import the PEM (Supports PKCS#1 or PKCS#8)
        rsa.ImportFromPem(pemContent.ToCharArray());

        // 3. Perform the same "Math" that the Key Vault HSM does
        // We use SHA256 and Pkcs1 padding to match standard OIDC/JWT signatures
        return rsa.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
    }
}