using System.Collections.Generic;
using LifePoint.Web.App_Start;
using LifePoint.Web.Areas.Api.Controllers;

namespace LifePoint.Web.Areas.Api.Models.UserAccounts
{
    public class UserAccountRoutes: IWebApiRoutes
    {
//        private readonly WebApiRoute<UserAccountsController,UserAccountsParameters> _userAccounts = 

        public IReadOnlyCollection<IWebApiRoute> Routes { get; private set; }
    }
}