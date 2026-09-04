using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Service;

public interface IInstitutiveSigner
{
    Task<byte[]> SignDataAsync(byte[] data);
}
