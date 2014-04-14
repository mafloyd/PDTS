using System.Web.Mvc;

namespace LifePoint.Web.Controllers
{

    public class AngularController : Controller
    {
        [HttpGet]
        //TODO: Add me back in when ready to leverage security
        //[Authorize]
        public virtual ActionResult Index()
        {
            return View();
        }
    }
}
