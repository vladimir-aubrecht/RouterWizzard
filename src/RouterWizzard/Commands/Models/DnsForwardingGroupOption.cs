using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

namespace RouterWizzard.Commands.Models
{
    [DebuggerDisplay("{GroupName}")]
    public class DnsForwardingGroupOption
    {
        public string GroupName { get; set; }
        public ISet<string> Domains { get; set; }
    }
}
