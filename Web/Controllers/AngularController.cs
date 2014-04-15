using System.Web.Mvc;

namespace LifePoint.Web.Controllers
{
    public partial class AngularController : Controller
    {
        [HttpGet]
        //TODO: Add me back in when ready to leverage security
        //[Authorize]
        public virtual ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        //TODO: Add me back in when ready to leverage security
        //[AuthorizeWithoutRedirect]
        public virtual ActionResult GetView(string sectionName, string viewName)
        {
            string pathName = string.IsNullOrWhiteSpace(sectionName) ? viewName : sectionName + "/" + viewName;
            return View("~/App/views/" + pathName + ".cshtml");
        }
    }
}