using Foundation;
using System;
using UIKit;

namespace RouterWizzard.Views
{
    public partial class AddDomainViewController : UIViewController
    {
        public AddDomainViewController (IntPtr handle) : base (handle)
        {
        }


        partial void SaveButton_Activated(UIBarButtonItem sender)
        {
            NavigationController.PopViewController(true);

            var originalController = NavigationController.TopViewController as DomainViewController;

            if (originalController != null)
            {
                var newDomain = DomainTextField.Text;
                originalController.AddDomain(newDomain);
            }
        }

        partial void CancelButton_Activated(UIBarButtonItem sender)
        {
            NavigationController.PopViewController(true);
        }
    }
}