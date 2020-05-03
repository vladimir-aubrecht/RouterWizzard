using System;
using Renci.SshNet;

namespace RouterWizzard.Commands.Ssh
{
    public class SshClientWrapper : ISshClient
    {
        private readonly SshClient sshClient;

        public SshClientWrapper(SshClient sshClient)
        {
            this.sshClient = sshClient ?? throw new ArgumentNullException(nameof(sshClient));
        }

        public void Dispose()
        {
            this.sshClient.Dispose();
        }

        public string Execute(string command)
        {
            if (!this.sshClient.IsConnected)
            {
                this.sshClient.Connect();
            }

            return this.sshClient.RunCommand(command).Execute();
        }
    }
}
