using System;
namespace RouterWizzard.Commands.Ssh
{
    internal interface ISshClient : IDisposable
    {
        string Execute(string command);
    }
}
