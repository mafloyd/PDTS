using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace LifePoint.Web.Areas.Api.Controllers
{
    public class UserAccountsController : ApiController
    {
        [HttpGet]
        // GET: api/UserAccounts
        //TODO: Returning temporary data fakes
        public IEnumerable<dynamic> Index()
        {
            var returnAccounts = new[]
            {
                new
                {
                    FirstName = "James",
                    LastName = "Davis",
                    Created = new DateTime().Date,
                    NtId = 1234
                },
                new
                {
                    FirstName = "Jim",
                    LastName = "Davis",
                    Created = new DateTime().Date,
                    NtId = 4321
                }
            };

            return returnAccounts.ToList().AsEnumerable();
        }

        [HttpGet]
        // GET: api/UserAccounts/5
        public IEnumerable<string> Get([FromUri] int id)
        {
            return new[] {"value3", "value4"};
        }

        // POST: api/UserAccounts
        public void Post([FromBody] string value)
        {
        }

        // PUT: api/UserAccounts/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE: api/UserAccounts/5
        public void Delete(int id)
        {
        }
    }
}