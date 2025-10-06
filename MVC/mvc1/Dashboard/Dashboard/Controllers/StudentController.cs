using Microsoft.AspNetCore.Mvc;

namespace Dashboard.Controllers
{
    public class StudentController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Add()
        {
            return View();
        }
   
    }
}
