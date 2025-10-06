using Dashboard.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Dashboard.Controllers
{
    public class StudentController : Controller
    {
        myContext db = new myContext();

        [Route("/Admin/Student")]
        public IActionResult Index()
        {
            var students= db.Students
                .Include(d=>d.department)
                .ToList();
            return View(students);
        }
        [HttpGet]
        [Route("/Admin/Student/Add")]
        public IActionResult Add()
        {
            var depts = db.Departments.ToList();
            return View(depts);
        }
        [HttpPost]
        [Route("/Admin/Student/Add")]
        public IActionResult Add(Student student)
        {
            db.Students.Add(student);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        [HttpGet]
        [Route("/Admin/Student/Details/{id}")]
        public IActionResult Details(int id)
        {
            var stu=db.Students
                .Include (d=>d.department)
                .FirstOrDefault(s=>s.StudentId==id);
            return View(stu);
        }
        [Route("/Admin/Student/Delete/{id}")]
        public IActionResult Delete(int id)
        {
            var stu = db.Students.FirstOrDefault(s => s.StudentId == id);
            if (stu == null)
            {
                return NotFound(); 
            }
            db.Students.Remove(stu);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        [HttpGet]
        [Route("/Admin/Student/Edit/{id}")]
        public IActionResult Edit(int id)
        {
            var student = db.Students.FirstOrDefault(s => s.StudentId == id);
            ViewBag.Department = db.Departments.ToList();
            return View(student);
        }
        [HttpPost]
        [Route("/Admin/Student/Edit/{id}")]
        public IActionResult Edit(Student student)
        {
            db.Students.Update(student);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

    }
}
