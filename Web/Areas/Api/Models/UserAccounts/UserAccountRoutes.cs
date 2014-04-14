using System.Collections.Generic;
using System.Collections.ObjectModel;
using LifePoint.Web.App_Start;
using LifePoint.Web.Areas.Api.Controllers;

namespace LifePoint.Web.Areas.Api.Models.UserAccounts
{
    public class UserAccountRoutes: IWebApiRoutes
    {
        private readonly WebApiRoute<UserAccountsController, UserAccountsParameters> _userAccountsGet =
            WebApiRoute.Create<UserAccountsController, UserAccountsParameters>(
                account => WebApiLocationTemplate.Create("api/useraccounts"));

        public IEnumerable<IWebApiRoute> Routes
        {
            get
            {
                return new IWebApiRoute[] {_userAccountsGet};
            }
        }
    }
}