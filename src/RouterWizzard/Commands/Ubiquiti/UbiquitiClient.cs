using System;
using RouterWizzard.Commands.Ssh;

namespace RouterWizzard.Commands.Ubiquiti
{
    internal class UbiquitiClient : IUbiquitiClient
    {
        private readonly ISshClient sshClient;

        public UbiquitiClient(ISshClient sshClient)
        {
            this.sshClient = sshClient ?? throw new ArgumentNullException(nameof(sshClient));
        }

        public void BeginSession()
        {
            var result = Execute("begin");
        }

        public void EndSession()
        {
            var result = Execute("end");
        }

        public string Show(string key)
        {
            var result = Execute($"show {key}");
            return result;
        }

        public void Set(string key)
        {
            var result = Execute($"set {key}");
        }

        public void Delete(string key)
        {
            var result = Execute($"delete {key}");
        }

        public void Commit()
        {
            var result = Execute("commit");
        }

        public void Save()
        {
            var result = Execute("save");
        }

        public void ExecuteInSavedSession(Action codeToExecuteFunc)
        {
            this.BeginSession();

            codeToExecuteFunc();

            this.Commit();
            this.Save();
            this.EndSession();
        }

        private string Execute(string key)
        {
            var command = $"/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper {key}";
            return this.sshClient.Execute(command);
        }
    }
}
