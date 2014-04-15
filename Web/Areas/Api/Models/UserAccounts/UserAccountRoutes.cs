using System.Collections.Generic;
using LifePoint.Web.App_Start;
using LifePoint.Web.Areas.Api.Controllers;

namespace LifePoint.Web.Areas.Api.Models.UserAccounts
{
    public class UserAccountRoutes: IWebApiRoutes
    {
        private readonly WebApiRoute<UserAccountsController, UserAccountsParameters> _userAccountsGet =
            WebApiRoute.Create<UserAccountsController, UserAccountsParameters>(
                account => WebApiLocationTemplate.Create("api/useraccounts/{id}/",account.Create(u=> u.UserId)));

        public IEnumerable<IWebApiRoute> Routes
        {
            get
            {
                return new IWebApiRoute[] {_userAccountsGet};
            }
        }
    }
}