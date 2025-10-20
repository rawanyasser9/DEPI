using Dashboard.Models;
using Dashboard.Repositories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Dashboard.Services;

namespace Dashboard.Controllers
{
    [Route("/admin/{controller}/{action=Index}/{id?}")]
    public class StudentController : Controller
    {
        IStudentService studentService;

        public StudentController(IStudentService _studentService)
        {
            studentService = _studentService;
        }

        public IActionResult Index()
        {
            var students = studentService.GetAll();
            return View(students);
        }

        [HttpGet]
        public IActionResult Add()
        {
            return View(studentService.GetStudentCreateViewModel());
        }
        [HttpPost]
        public IActionResult Add(StudentCreateViewModel vm)
        {
            var exists = studentService.EmailExists(vm.student.Email);
            if (exists)
            {
                ModelState.AddModelError("", "Email already exists");
            }
            if (ModelState.IsValid == false)
            {
                return View(studentService.GetStudentCreateViewModel(vm.student));
            }
            studentService.Add(vm.student);
            TempData["msg"] = "student created successfuly";
            return RedirectToAction("Index");
        }
        [HttpGet]
        public IActionResult Details(int id)
        {
            var stu = studentService.GetByIdWithDept(id);
            if (stu == null)
                return NotFound();

            return View(stu);
        }
        [HttpGet]
        public IActionResult Delete(int? id)
        {

            var student = studentService.GetByIdWithDept((int)id);
            if (student == null)
                return NotFound();
            return View(student);
        }
        [HttpPost, ActionName("Delete")]
        public IActionResult ConDelete(int? id)
        {
            if (id == null)
                return BadRequest();
            var student = studentService.GetById((int)id);
            if (student == null)
                return NotFound();
            studentService.Delete(student);
            TempData["msg"] = "student deleted successfuly";
            return RedirectToAction("index");
        }
        [HttpGet]
        public IActionResult Edit(int? id)
        {
            var student = studentService.GetById((int)id);
            if (student == null)
                return NotFound();
            return View(studentService.GetStudentCreateViewModel());
        }
        [HttpPost]
        public IActionResult Edit(Student student)
        {
            studentService.Update(student);
            TempData["msg"] = "student updated successfuly";
            return RedirectToAction("index");
        }

        public IActionResult CheckEmail([FromQuery(Name = "student.Email")] string email)
        {
            if (studentService.EmailExists(email))
            {
                return Json($"Email is already exists");
            }
            else
            {
                return Json(true);
            }
        }
    }
}
