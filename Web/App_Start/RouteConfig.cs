using System.Web.Mvc;
using System.Web.Routing;

namespace LifePoint.Web.App_Start
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.MapRoute("AngularRoot", "", MVC.Angular.Index());
        }
    }
}
