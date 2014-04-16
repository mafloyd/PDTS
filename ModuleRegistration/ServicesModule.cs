using Autofac;
using Autofac.Core;
using LifePoint.Repository;
using LifePoint.Services.UserAccounts;

namespace LifePoint.ModuleRegistration
{
    public class ServicesModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            //TODO: Check arguments here

            builder.RegisterType<Container>()
                .AsSelf();

            builder.RegisterType<UserAccountsService>()
                .As<IRepository<UserAccountsService>>();
        }
    }
}