using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace LifePoint.Web.Areas.Api.Models.UserAccounts
{
    [DataContract]
    public class UserAccountsParameters
    {
        [DataMember]
        public int UserId { get; set; }
        
        [DataMember]
        public string NtId { get; set; }

        [DataMember]
        public string LastName { get; set; }

        [DataMember]
        public string FirstName { get; set; }
    }
}