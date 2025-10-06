using Dashboard.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Dashboard.Controllers
{
    public class DepartmentController : Controller
    {
        myContext db = new myContext();
        [Route("/Admin/Department")]
        public IActionResult Index()
        {
            var depts = db.Departments.ToList();
            return View(depts);
        }
        [HttpGet]
        [Route("/Admin/Department/Add")]
        public IActionResult Add()
        {
            return View();
        }
        [HttpPost]
        [Route("/Admin/Department/Add")]
        public IActionResult Add(Department dept)
        {
            db.Departments.Add(dept);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        [HttpGet]
        [Route("/Admin/Department/Edit/{id}")]
        public IActionResult Edit(int id)
        {
            var dept = db.Departments.FirstOrDefault(s => s.Id == id);
            return View(dept);
        }
        [HttpPost]
        [Route("/Admin/Department/Edit/{id}")]
        public IActionResult Edit(Department dept)
        {
            db.Departments.Update(dept);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        [Route("/Admin/Department/Delete/{id}")]
        public IActionResult Delete(int id)
        {
            var dept = db.Departments.FirstOrDefault(s => s.Id == id);
            if (dept == null)
            {
                return NotFound();
            }
            db.Departments.Remove(dept);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        [HttpGet]
        [Route("/Admin/Department/Details/{id}")]
        public IActionResult Details(int id)
        {
            var dept = db.Departments.FirstOrDefault(s => s.Id == id);
            return View(dept);
        }

    }
}
