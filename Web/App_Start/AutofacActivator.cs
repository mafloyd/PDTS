using System.Reflection;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Autofac;
using Autofac.Integration.Mvc;
using Autofac.Integration.WebApi;
using LifePoint.Web.App_Start;

[assembly: PreApplicationStartMethod(typeof (AutofacActivator), "Start")]

namespace LifePoint.Web.App_Start

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

        //TODO: Remove me later if I am not being utilized
        public static void ConfigureWebApi(IContainer container)
        {
            var webApiBuilder = new ContainerBuilder();

            webApiBuilder.RegisterApiControllers(Assembly.GetExecutingAssembly());
            webApiBuilder.Update(container);
        }
    }
}