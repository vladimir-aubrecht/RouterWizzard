using System;

namespace RouterWizzard.Commands.Ubiquiti
{
    internal interface IUbiquitiClient
    {
        void BeginSession();
        void EndSession();
        void Commit();
        void Delete(string key);
        void Save();
        void Set(string key);
        string Show(string key);
        void ExecuteInSavedSession(Action codeToExecuteFunc);
    }
}