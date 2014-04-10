using System.Linq;
using System.Net.Http.Formatting;
using System.Reflection;
using System.Web.Http;
using Autofac;
using Autofac.Integration.Mvc;
using Autofac.Integration.WebApi;
using LifePoint.Web.App_Start;
using Newtonsoft.Json;
using Module = Autofac.Module;

namespace LifePoint.Web
{
    public class WebModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            //TODO: Add argument check implementation here and for all other layer method implementations

            ConfigureMvc(builder);
            ConfigureWebApi(builder);
            ConfigureWebApiRouting(builder);

            builder.RegisterType<JsonMediaTypeFormatter>()
                .OnActivated(args =>
                {
                    args.Instance.SerializerSettings =
                        args.Context.Resolve<JsonSerializerSettings>(args.Parameters);
                })
                .AsSelf();
        }

        private static void ConfigureMvc(ContainerBuilder builder)
        {
            builder.RegisterControllers(Assembly.GetExecutingAssembly());
            builder.RegisterFilterProvider();
            builder.RegisterModule(new AutofacWebTypesModule());
        }

        private static void ConfigureWebApi(ContainerBuilder builder)
        {
            builder.RegisterApiControllers(Assembly.GetExecutingAssembly());

            builder.RegisterInstance(GlobalConfiguration.Configuration.Services.GetHttpControllerSelector());
        }

        private static void ConfigureWebApiRouting(ContainerBuilder builder)
        {
            var routses =
                typeof (WebModule).Assembly.GetTypes()
                    .Where(t => t.GetInterface(typeof (IWebApiRoutes).FullName) != null)
                    .ToArray();

            builder.RegisterTypes(routses).AsSelf();
            builder.RegisterTypes(routses).AsImplementedInterfaces();

            //TODO: This may not be needed. Remove later if not utilized
            builder.RegisterType<WebApiRoutesRegistrar>().AsSelf();
        }
    }
}