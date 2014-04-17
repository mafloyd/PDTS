using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;
using System.Web.Routing;

namespace Web
{
    public class WebApiRoutesRegistrar
    {
        private readonly IHttpControllerSelector _controllerSelector;
        //TODO: Research IEnumerable to make sure it is an acceptable replacement of IReadOnlyCollection
        private readonly IEnumerable<IWebApiRoute> _routes;

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
                route.Template.AsString(),
                controllerName
                );
        }
    }

    public static class WebApiRoute
    {
        public static WebApiRoute<TController, TParameters> Create<TController, TParameters>(
            Func<IWebApiParameterFactory<TParameters>, WebApiLocationTemplate> templateSelector)
            where TController : IHttpController
        {
            //TODO: Check args here

            return new WebApiRoute<TController, TParameters>(
                templateSelector(new WebApiParameterFactory<TParameters>()),
                string.Format(CultureInfo.InvariantCulture, "{0}_{1}",
                    typeof (TController).Name,
                    typeof (TParameters).Name));
        }
    }

    public class WebApiRoute<TController, TParameters> : IWebApiRoute<TParameters> where TController : IHttpController
    {
        private readonly string _name;
        private readonly WebApiLocationTemplate _template;

        public WebApiRoute(WebApiLocationTemplate template, string name)
        {
            //TODO: Check args

            _template = template;
            _name = name;
        }

        public WebApiLocationTemplate Template
        {
            get { return _template; }
        }

        public Type ControllerType
        {
            get { return typeof (TController); }
        }

        public Type ParametersType
        {
            get { return typeof (TParameters); }
        }

        public string Name
        {
            get { return _name; }
        }
    }

    public class WebApiParameter
    {
        private readonly string _name;

        public WebApiParameter(string name, Type parameterType)
        {
            //TODO: Add args check
            _name = name;
        }

        public string Name
        {
            get { return _name; }
        }
    }

    public class WebApiLocationTemplate
    {
        private readonly ReadOnlyCollection<string> _fragments;
        private readonly ReadOnlyCollection<WebApiParameter> _paths;

        private WebApiLocationTemplate(ReadOnlyCollection<string> fragments, ReadOnlyCollection<WebApiParameter> paths)
        {
            //TODO: Add arg checks here

            if (fragments.Count == 0)
            {
                throw new ArgumentOutOfRangeException();
            }
            if (fragments.Count != paths.Count && fragments.Count != paths.Count + 1)
            {
                throw new ArgumentOutOfRangeException();
            }

            _fragments = fragments;
            _paths = paths;
        }

        public static WebApiLocationTemplate Create(params object[] paths)
        {
            //TODO: Add args check
            if (paths.Length == 0)
            {
                throw new ArgumentOutOfRangeException();
            }
            var grouped = paths.Select((path, i) => new {isFragment = i%2 == 0, path})
                .GroupBy(p => p.isFragment, p => p.path);

            var pathSegments = new List<string>();
            foreach (var segment in grouped.Single(g => g.Key).Select(i => i as string))
            {
                if (string.IsNullOrWhiteSpace(segment))
                {
                    throw new ArgumentOutOfRangeException();
                }
                pathSegments.Add(segment);
            }

            var parameters = new List<WebApiParameter>();
            if (grouped.Any(i => !i.Key))
            {
                parameters.AddRange(from parameter in grouped.SingleOrDefault(i => !i.Key)
                    where parameter != null
                    select parameter as WebApiParameter);
            }
            return new WebApiLocationTemplate(
                new ReadOnlyCollection<string>(pathSegments),
                new ReadOnlyCollection<WebApiParameter>(parameters)
                );
        }

        public string AsString()
        {
            var strings = _fragments.Zip(_paths.Select(p => p.Name), (f, p) => new[] {f, "{", p, "}"})
                .SelectMany(_ => _);
            if (_fragments.Count == _paths.Count + 1)
            {
                strings = strings.Concat(new[] {_fragments[_fragments.Count - 1]});
            }
            return string.Join("", strings);
        }
    }

    public interface IWebApiParameterFactory<TParameters>
    {
        WebApiParameter Create<TProperty>(Expression<Func<TParameters, TProperty>> propertyExpression);
    }

    internal class WebApiParameterFactory<TParameters> : IWebApiParameterFactory<TParameters>
    {
        public WebApiParameter Create<TProperty>(Expression<Func<TParameters, TProperty>> propertyExpression)
        {
            //TODO: Add arg check
            var baseName = propertyExpression.Parameters.Single().Name;
            var name = baseName.Substring(0, 1).ToLowerInvariant() + baseName.Substring(1);
            return new WebApiParameter(name, typeof (TProperty));
        }
    }

    public interface IWebApiRoutes
    {
        IEnumerable<IWebApiRoute> Routes { get; }
    }

    public interface IWebApiRoute
    {
        WebApiLocationTemplate Template { get; }
        Type ControllerType { get; }
        string Name { get; }
    }

    public interface IWebApiRoute<in TParameters> : IWebApiRoute
    {
    }
}