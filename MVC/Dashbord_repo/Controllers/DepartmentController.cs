using Dashboard.Models;
using Dashboard.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Dashboard.Controllers
{

    public class DepartmentController : Controller
    {
        IService<Department> deptService;


        public DepartmentController(IService<Department> _deptService)
        {
            deptService = _deptService;
        }
        [Route("/Admin/Department")]

        public IActionResult Index()
        {
            var depts = deptService.GetAll();
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
            if (!ModelState.IsValid)
                return View(dept);

            deptService.Add(dept);
            TempData["msg"] = "Department created successfully";
            return RedirectToAction("Index");
        }

        [HttpGet]
        [Route("/Admin/Department/Edit/{id}")]
        public IActionResult Edit(int id)
        {
            var dept = deptService.GetById(id);
            if (dept == null)
                return NotFound();

            return View(dept);
        }
        [HttpPost]
        [Route("/Admin/Department/Edit/{id}")]
        public IActionResult Edit(Department dept)
        {
            if (!ModelState.IsValid)
                return View(dept);

            deptService.Update(dept);
            TempData["msg"] = "Department updated successfully";
            return RedirectToAction("Index");
        }

        [Route("/Admin/Department/Delete/{id}")]
        public IActionResult Delete(int id)
        {
            var dept = deptService.GetById(id);
            if (dept == null)
                return NotFound();

            deptService.Delete(dept);
            TempData["msg"] = "Department deleted successfully";
            return RedirectToAction("Index");
        }
        [HttpGet]
        [Route("/Admin/Department/Details/{id}")]
        public IActionResult Details(int id)
        {
            var dept = deptService.GetById(id);
            if (dept == null)
                return NotFound();

            return View(dept);
        }

    }
}
