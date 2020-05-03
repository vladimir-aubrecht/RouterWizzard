using System;
using System.Linq;
using System.Threading.Tasks;
using Foundation;
using Renci.SshNet;
using RouterWizzard.Commands.Ssh;
using RouterWizzard.Commands.Ubiquiti;
using UIKit;
using Xamarin.Essentials;

namespace RouterWizzard
{
    public partial class DomainViewController : UIViewController
    {
        public DomainViewController(IntPtr handle) : base(handle)
        {
        }

        public override void ViewWillAppear(bool animated)
        {
            base.ViewWillAppear(animated);
            // Perform any additional setup after loading the view, typically from a nib.
            var hostname = Preferences.Get("hostname", "");
            var username = Preferences.Get("username", "");
            var password = Preferences.Get("password", "");

            var connectionInfo = new ConnectionInfo(hostname, username, new PasswordAuthenticationMethod(username, password));
            using (var client = new SshClientWrapper(new SshClient(connectionInfo)))
            {
                var commandExecutor = new UbiquitiCommandExecutor(new UbiquitiClient(client));
                var groupOptions = commandExecutor.FetchDnsForwardingGroupOptions();
                var groupNames = groupOptions.Select(i => i.GroupName).ToArray();

                //commandExecutor.AddDomainToOptionsGroups("xxx.com", groupNames);
                //commandExecutor.RemoveDomainFromOptionsGroups("xxx.com", groupNames);

                //result = commandExecutor.FetchDnsForwardingIpSets();
                //commandExecutor.RemoveDomainFromOptionsGroup(result[0].GroupName, "xxx.com");

                var domains = groupOptions.First().Domains;
                var domainIconProvider = new DomainIconProvider();
                var domainsWithImages = domains.ToDictionary(k => k, i => domainIconProvider.LoadImage(i));
                this.DomainTableView.Source = new DomainTableSource(domainsWithImages);
            }
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }
    }
}