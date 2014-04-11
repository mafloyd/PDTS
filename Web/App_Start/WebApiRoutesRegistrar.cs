using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Dispatcher;
using System.Web.Routing;

namespace LifePoint.Web.App_Start
{
    public class WebApiRoutesRegistrar
    {
        private readonly IReadOnlyCollection<IWebApiRoute> _routes;
        private readonly IHttpControllerSelector _controllerSelector;

        public WebApiRoutesRegistrar(IHttpControllerSelector controllerSelector, IEnumerable<IWebApiRoutes> routes)
        {
            //TODO: Add argument check here

            _controllerSelector = controllerSelector;
            _routes = routes.SelectMany(rs => rs.Routes).ToList().AsReadOnly();
        }

        public void Register(RouteCollection routes)
        {
            //TODO: Add argument check 

            foreach (var route in _routes)
            {
                Register(routes, route);
            }
        }

        private void Register(RouteCollection routes, IWebApiRoute route)
        {
            var controller =
                _controllerSelector.GetControllerMapping()
                    .Values.FirstOrDefault(item => item.ControllerType == route.ControllerType);

            if (controller == null)
            {
                throw new ConfigurationErrorsException("No controller found for " +
                                                       route.ControllerType.FullName);
            }

            var controllerName = controller.ControllerName;

            routes.MapHttpRoute(
                route.Name,
                route.Template,
                controllerName
                );
        }
    }

    public interface IWebApiRoutes
    {
        IReadOnlyCollection<IWebApiRoute> Routes { get; }
    }

    public interface IWebApiRoute
    {
        string Template { get; }
        Type ControllerType { get; }
        Type ParametersType { get; }
        string Name { get; }
    }
}