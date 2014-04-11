using System.Web.Http;
using System.Web.Mvc;
using LifePoint.Web.App_Start;

namespace LifePoint.Web.Areas.Api
{
    public class ApiAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get { return "Api"; }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            var registrar =
                (WebApiRoutesRegistrar)
                    (GlobalConfiguration.Configuration.DependencyResolver).GetService(
                        typeof (WebApiRoutesRegistrar));

            registrar.Register(context.Routes);
        }
    }
}