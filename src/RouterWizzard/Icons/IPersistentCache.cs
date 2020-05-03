using BackgroundTasks;

namespace RouterWizzard.Icons
{
    internal interface IPersistentCache
    {
        void Clear();

        byte[] Read(string key);
        void Store(string key, byte[] value);
    }
}