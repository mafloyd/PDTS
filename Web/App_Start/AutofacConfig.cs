﻿using System;
using Autofac;
using LifePoint.ModuleRegistration;
using LifePoint.Web;

namespace Web
{
    public class AutofacConfig
    {
        private static readonly Lazy<IContainer> Container = new Lazy<IContainer>(BuildContainer);

        public static IContainer GetConfiguredContainer()
        {
            return Container.Value;
        }

        private static IContainer BuildContainer()
        {
            var builder = new ContainerBuilder();

            builder.RegisterModule(new JsonModule());
            builder.RegisterModule(new WebModule());

            return builder.Build();
        }
    }
}