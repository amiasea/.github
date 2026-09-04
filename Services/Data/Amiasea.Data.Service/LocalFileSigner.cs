using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Service;

public class LocalFileSigner(string pemPath) : IInstitutiveSigner
{
    public Task<byte[]> SignDataAsync(byte[] data) =>
        Task.FromResult(LocalRsaHelper.Sign(pemPath, data));
}