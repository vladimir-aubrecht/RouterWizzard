using System;
using System.Collections.Generic;
using System.Linq;
using Foundation;
using UIKit;

namespace RouterWizzard.Views
{
    internal class DomainTableSource : UITableViewSource
    {
        private IDictionary<string, UIImage> domainsWithImages;
        private IList<string> TableItems;
        private string CellIdentifier = "TableCell";

        public delegate void RemoveDomain(string domain);
        public event RemoveDomain OnRemovedDomain;

        public DomainTableSource(IDictionary<string, UIImage> domainsWithImages)
        {
            this.domainsWithImages = domainsWithImages;
            this.TableItems = domainsWithImages.Keys.ToList();
        }

        public override nint RowsInSection(UITableView tableview, nint section)
        {
            return TableItems.Count;
        }

        public override UITableViewCell GetCell(UITableView tableView, NSIndexPath indexPath)
        {
            UITableViewCell cell = tableView.DequeueReusableCell(CellIdentifier);
            string item = TableItems[indexPath.Row];

            //if there are no cells to reuse, create a new one
            if (cell == null)
            {
                cell = new UITableViewCell(UITableViewCellStyle.Default, CellIdentifier);
                cell.ImageView.Image = domainsWithImages[item];
            }

            cell.TextLabel.Text = item;

            return cell;
        }

        public override void CommitEditingStyle(UITableView tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath indexPath)
        {
            switch (editingStyle)
            {
                case UITableViewCellEditingStyle.Delete:
                    var removedDomain = this.TableItems[indexPath.Row];
                    this.TableItems.RemoveAt(indexPath.Row);
                    tableView.DeleteRows(new NSIndexPath[] { indexPath }, UITableViewRowAnimation.Fade);
                    OnRemovedDomain?.Invoke(removedDomain);
                    break;
            }
        }

        public override bool CanEditRow(UITableView tableView, NSIndexPath indexPath)
        {
            return true;
        }
    }
}
