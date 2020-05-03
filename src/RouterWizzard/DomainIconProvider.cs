using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using Foundation;
using UIKit;

namespace RouterWizzard
{
    public class DomainIconProvider
    {
        public UIImage LoadImage(string domain)
        {
            return UIImage.ActionsImage;
            try
            {
                var url = $"http://{domain}/favicon.ico";
                return FetchImage(url);
            }
            catch (Exception ex)
            {
                return UIImage.ActionsImage;
            }
        }

        private static UIImage FetchImage(string url)
        {
            var request = HttpWebRequest.CreateHttp(url);
            request.Timeout = 10000;
            request.AllowAutoRedirect = true;

            var response = (HttpWebResponse)request.GetResponse();

            if ((int)response.StatusCode >= 400)
            {
                return UIImage.ActionsImage;
            }

            using (var stream = response.GetResponseStream())
            {
                var imageData = NSData.FromStream(stream);
                return UIImage.LoadFromData(imageData);
            }
        }
    }
}
