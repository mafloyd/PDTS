using System.Web.Mvc;
using System.Web.Routing;

namespace LifePoint.Web.App_Start
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //TODO: The next 2 lines will probably not get used;
            routes.MapRoute("AngularViewSections", "App/views/{section}/{viewName}.html", MVC.Angular.GetView());
            routes.MapRoute("AngularViews", "App/views/{viewName}.html", MVC.Angular.GetView());

            routes.MapRoute("AngularRoot", "", MVC.Angular.Index());
        }
    }
}