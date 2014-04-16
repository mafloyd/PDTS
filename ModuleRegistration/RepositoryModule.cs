using Autofac;
using Autofac.Core;
using LifePoint.Repository;
using LifePoint.Repository.UserAccounts;

namespace LifePoint.ModuleRegistration
{
    public class RepositoryModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            //TODO: Check arguments here

            builder.RegisterType<Container>()
                .AsSelf();

            builder.RegisterType<UserAccountsRepository>()
                .As<IRepository<UserAccountsRepository>>();
        }
    }
}