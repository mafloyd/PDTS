using System.Collections.Generic;
using LifePoint.Web.Areas.Api.Controllers;
using Web;

namespace LifePoint.Web.Areas.Api.Models.UserAccounts
{
    public class UserAccountRoutes : IWebApiRoutes
    {
        private readonly WebApiRoute<UserAccountsController, UserAccountsParameters> _userAccounts =
            WebApiRoute.Create<UserAccountsController, UserAccountsParameters>(
                u => WebApiLocationTemplate.Create("api/useraccounts"));

        private readonly WebApiRoute<UserAccountsController, UserAccountsParameters> _userAccountsGet =
            WebApiRoute.Create<UserAccountsController, UserAccountsParameters>(
                account => WebApiLocationTemplate.Create("api/useraccounts/{id}/", account.Create(u => u.UserId)));

        public IEnumerable<IWebApiRoute> Routes
        {
            get { return new IWebApiRoute[] {_userAccountsGet}; }
        }
    }
}