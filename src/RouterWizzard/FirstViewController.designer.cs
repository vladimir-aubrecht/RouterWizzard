// WARNING
//
// This file has been generated automatically by Visual Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
using System.CodeDom.Compiler;

namespace RouterWizzard
{
    [Register ("FirstViewController")]
    partial class FirstViewController
    {
        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UITableView DomainTableView { get; set; }

        void ReleaseDesignerOutlets ()
        {
            if (DomainTableView != null) {
                DomainTableView.Dispose ();
                DomainTableView = null;
            }
        }
    }
}