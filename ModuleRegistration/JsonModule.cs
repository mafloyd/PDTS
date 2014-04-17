using System.Linq;
using Autofac;
using Autofac.Core;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace LifePoint.ModuleRegistration
{
    public class JsonModule : Module
    {
        private const string CamelCase = "C8210A10-C9FE-4491-8783-880EDFC05DE4";

        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<CamelCasePropertyNamesContractResolver>()
                .Named<IContractResolver>(CamelCase);
            builder.RegisterType<JsonSerializerSettings>()
                .OnActivated(SetCamelCase)
                .AsSelf();
        }

        private static void SetCamelCase(IActivatedEventArgs<JsonSerializerSettings> args)
        {
            //TODO: Perform argument check here

            var componentContext = args.Context;
            var parameters = (args.Parameters ?? Enumerable.Empty<Parameter>()).ToArray();
            var settings = args.Instance;

            settings.ContractResolver = componentContext.ResolveNamed<IContractResolver>(CamelCase, parameters);
        }
    }
}