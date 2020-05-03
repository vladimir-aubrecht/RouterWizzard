using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using RouterWizzard.Commands.Ssh;
using RouterWizzard.Commands.Ubiquiti.Models;

namespace RouterWizzard.Commands.Ubiquiti
{
    internal class UbiquitiCommandExecutor
    {
        private readonly IUbiquitiClient ubiquitiClient;

        public UbiquitiCommandExecutor(IUbiquitiClient ubiquitiClient)
        {
            this.ubiquitiClient = ubiquitiClient ?? throw new ArgumentNullException(nameof(ubiquitiClient));
        }

        public void RemoveDomainFromOptionsGroups(string domain, params string[] groupNames)
        {
            ubiquitiClient.ExecuteInSavedSession(() =>
            {
                foreach (var groupName in groupNames)
                {
                    ModifyDomainsInOptionGroup(groupName, (domains) => domains.Remove(domain));
                }
            });
        }

        public void AddDomainToOptionsGroups(string domain, params string[] groupNames)
        {
            ubiquitiClient.ExecuteInSavedSession(() =>
            {
                foreach (var groupName in groupNames)
                {
                    ModifyDomainsInOptionGroup(groupName, (domains) => domains.Add(domain));
                }
            });
        }

        public void RemoveDomainFromOptionsGroup(string groupName, string domain)
        {
            ubiquitiClient.ExecuteInSavedSession(() =>
            {
                ModifyDomainsInOptionGroup(groupName, (domains) => domains.Remove(domain));
            });
        }

        public void AddDomainToOptionsGroup(string groupName, string domain)
        {
            ubiquitiClient.ExecuteInSavedSession(() =>
            {
                ModifyDomainsInOptionGroup(groupName, (domains) => domains.Add(domain));
            });
        }

        private void ModifyDomainsInOptionGroup(string groupName, Action<ISet<string>> domainModificationFunc)
        {
            var ipSet = FetchDnsForwardingGroupOptions().Where(i => i.GroupName == groupName).First();
            var originalSet = SerializeOptions(ipSet.GroupName, ipSet.Domains);
            var originalOptions = ubiquitiClient.Show($"service dns forwarding options");

            var newDomains = new HashSet<string>(ipSet.Domains);
            domainModificationFunc(newDomains);

            if (newDomains.Count == ipSet.Domains.Count)
            {
                return;
            }

            var newSet = SerializeOptions(ipSet.GroupName, newDomains);
            var newOptions = originalOptions.Replace(originalSet, newSet)
                .Split('\n', StringSplitOptions.RemoveEmptyEntries)
                .Select(i => i.Trim())
                .Where(i => !i.StartsWith("-options"))
                .Select(i => i.TrimStart('+'))
                .ToList();

            ubiquitiClient.Delete($"service dns forwarding options");

            foreach (var newOption in newOptions)
            {
                ubiquitiClient.Set($"service dns forwarding {newOption}");
            }
        }

        public IList<DnsForwardingGroupOption> FetchDnsForwardingGroupOptions()
        {
            var result = ubiquitiClient.Show("service dns forwarding options");
            return DeserializeOptions(result, (groupName, domains) => new DnsForwardingGroupOption { GroupName = groupName, Domains = domains });
        }

        private static string SerializeOptions(string groupName, ISet<string> domains)
        {
            return $"/{String.Join('/', domains)}/{groupName}";
        }

        private static IList<T> DeserializeOptions<T>(string stringToParse, Func<string, ISet<string>, T> resultCreateFunc)
        {
            string[] allowedPrefixes = { "ipset", "server" };
            var ipSetOptions = stringToParse.Split('\n', StringSplitOptions.RemoveEmptyEntries).Where(i => allowedPrefixes.Any(prefix => i.Trim().StartsWith($"options {prefix}=")));

            return ipSetOptions.Select(i => i.Split('=', StringSplitOptions.RemoveEmptyEntries)[1]).Select(i =>
            {
                var splittedString = i.Split('/', StringSplitOptions.RemoveEmptyEntries);
                return resultCreateFunc(splittedString[^1], splittedString.Take(splittedString.Length - 1).ToHashSet());
            }).ToList();
        }
    }
}
