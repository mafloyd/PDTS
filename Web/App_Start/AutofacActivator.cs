using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Autofac.Integration.Mvc;
using Autofac.Integration.WebApi;
using Web;

[assembly: PreApplicationStartMethod(typeof (AutofacActivator), "Start")]

namespace Web

{
    public class AutofacActivator
    {
        public static void Start()
        {
            var configuredContainer = AutofacConfig.GetConfiguredContainer();

            DependencyResolver.SetResolver(new AutofacDependencyResolver(configuredContainer));
            GlobalConfiguration.Configuration.DependencyResolver =
                new AutofacWebApiDependencyResolver(configuredContainer);
        }
    }
}