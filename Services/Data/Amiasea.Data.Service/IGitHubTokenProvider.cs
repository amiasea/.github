using System;
using System.Collections.Generic;
using System.Text;

namespace Amiasea.Data.Service;

public interface IGitHubTokenProvider
{
    Task<string> GetTokenAsync();
}