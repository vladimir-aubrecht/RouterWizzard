// WARNING
//
// This file has been generated automatically by Visual Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
using System.CodeDom.Compiler;

namespace RouterWizzard.Views
{
    [Register ("DomainViewController")]
    partial class DomainViewController
    {
        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UITableView DomainTableView { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIBarButtonItem RefreshButton { get; set; }

        [Action ("RefreshButton_Activated:")]
        [GeneratedCode ("iOS Designer", "1.0")]
        partial void RefreshButton_Activated (UIKit.UIBarButtonItem sender);

        void ReleaseDesignerOutlets ()
        {
            if (DomainTableView != null) {
                DomainTableView.Dispose ();
                DomainTableView = null;
            }

            if (RefreshButton != null) {
                RefreshButton.Dispose ();
                RefreshButton = null;
            }
        }
    }
}