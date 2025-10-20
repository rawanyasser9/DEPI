using Microsoft.AspNetCore.Mvc;

namespace WebApplicationMVC.Controllers
{
    public class AdminController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
