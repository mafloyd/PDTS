using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace LifePoint.Web.Areas.Api.Controllers
{
    public class UserAccountsController : ApiController
    {
        // GET: api/UserAccounts
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/UserAccounts/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/UserAccounts
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/UserAccounts/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/UserAccounts/5
        public void Delete(int id)
        {
        }
    }
}
