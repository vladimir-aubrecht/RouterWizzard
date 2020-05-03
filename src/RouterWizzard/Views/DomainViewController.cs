using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Foundation;
using Renci.SshNet;
using RouterWizzard.Commands;
using RouterWizzard.Commands.Ssh;
using RouterWizzard.Commands.Ubiquiti;
using RouterWizzard.Icons;
using UIKit;
using Xamarin.Essentials;
using Xamarin.Forms;

namespace RouterWizzard.Views
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

            Execute((exec) => LoadDomains(exec));
        }

        private void LoadDomains(ICommandExecutor exec)
        {
            var groupOptions = exec.FetchDnsForwardingGroupOptions();
            var groupNames = groupOptions.Select(i => i.GroupName).ToArray();

            var domains = groupOptions.First().Domains;
            var domainIconProvider = new DomainIconProvider();
            var cacheProvider = new PersistentCache();
            var domainsWithImages = domains.ToDictionary(k => k, i =>
            {
                cacheProvider.Clear();
                var cacheData = cacheProvider.Read(i);

                if (cacheData == null)
                {
                    var image = UIImage.FromBundle("UnknownDomain");
                    try
                    {
                        image = domainIconProvider.LoadImage(i);

                        if (image != null)
                        {
                            var imageData = image.AsPNG();
                            cacheProvider.Store(i, imageData.ToArray());
                            return image;
                        }

                        return UIImage.FromBundle("UnknownDomain");
                    }
                    catch (WebException ex) when (ex.Status == WebExceptionStatus.NameResolutionFailure)
                    {
                        var imageData = image.AsPNG();
                        cacheProvider.Store(i, imageData.ToArray());
                        return image;
                    }
                    catch (Exception ex)
                    {
                        return image;
                    }
                }

                return UIImage.LoadFromData(NSData.FromArray(cacheData));
            });

            var tableViewSource = new DomainTableSource(domainsWithImages);
            tableViewSource.OnRemovedDomain += TableViewSource_OnRemovedDomain;

            this.DomainTableView.Source = tableViewSource;
        }

        private void Execute(Action<ICommandExecutor> actionExecutor)
        {
            var hostname = Preferences.Get("hostname", "");
            var username = Preferences.Get("username", "");
            var password = Preferences.Get("password", "");

            var connectionInfo = new ConnectionInfo(hostname, username, new PasswordAuthenticationMethod(username, password));
            using (var client = new SshClientWrapper(new SshClient(connectionInfo)))
            {
                var commandExecutor = new UbiquitiCommandExecutor(new UbiquitiClient(client));
                actionExecutor?.Invoke(commandExecutor);
            }
        }

        private void TableViewSource_OnRemovedDomain(string domain)
        {
            Execute((exec) =>
            {
                var groupOptions = exec.FetchDnsForwardingGroupOptions();
                var groupNames = groupOptions.Select(i => i.GroupName).ToArray();
                exec.RemoveDomainFromOptionsGroups(domain, groupNames);
            });
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }

        public void AddDomain(string domain)
        {
            Execute((exec) =>
            {
                var groupOptions = exec.FetchDnsForwardingGroupOptions();
                var groupNames = groupOptions.Select(i => i.GroupName).ToArray();
                exec.AddDomainToOptionsGroups(domain, groupNames);
            });
        }

        partial void RefreshButton_Activated(UIBarButtonItem sender)
        {
            Execute((exec) => LoadDomains(exec));
        }
    }
}