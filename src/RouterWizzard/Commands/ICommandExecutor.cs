using RouterWizzard.Commands.Models;
using System.Collections.Generic;

namespace RouterWizzard.Commands
{
    internal interface ICommandExecutor
    {
        void AddDomainToOptionsGroup(string groupName, string domain);
        void AddDomainToOptionsGroups(string domain, params string[] groupNames);
        IList<DnsForwardingGroupOption> FetchDnsForwardingGroupOptions();
        void RemoveDomainFromOptionsGroup(string groupName, string domain);
        void RemoveDomainFromOptionsGroups(string domain, params string[] groupNames);
    }
}
