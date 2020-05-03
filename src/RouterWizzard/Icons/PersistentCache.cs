using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

using Foundation;
using UIKit;
using Xamarin.Essentials;
using Xamarin.Forms;

namespace RouterWizzard.Icons
{
    internal class PersistentCache : IPersistentCache
    {
        private readonly string cacheDir = FileSystem.CacheDirectory;

        public void Clear()
        {
            var files = Directory.GetFiles(cacheDir);

        }

        public void Store(string key, byte[] value)
        {
            var filePath = Path.Combine(cacheDir, key);

            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }

            File.WriteAllBytes(filePath, value);
        }

        public byte[] Read(string key)
        {
            var filePath = Path.Combine(cacheDir, key);

            if (File.Exists(filePath))
            {
                return File.ReadAllBytes(filePath);
            }

            return null;
        }
    }
}