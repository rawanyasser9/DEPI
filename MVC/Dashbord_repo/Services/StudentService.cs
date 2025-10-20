using Dashboard .Models;
using Dashboard.Repositories;

namespace Dashboard.Services
{
    public class StudentService : GenericService<Student>, IStudentService
    {
        IStudentRepository stdRepo;
        IService<Department> deptService;
        public StudentService(IStudentRepository studentRepository , IService<Department> _deptService) : base(studentRepository)
        {
            stdRepo = studentRepository;
            deptService = _deptService;
        }
        public bool EmailExists(string email)
        {
            return stdRepo.EmailExists(email);
        }

        public Student? GetByIdWithDept(int id)
        {
            return stdRepo.GetByIdWithDept(id);
        }

        public StudentCreateViewModel GetStudentCreateViewModel(Student? std = null)
        {
            return new StudentCreateViewModel()
            {
                student = std ?? new Student(),
                departments = deptService.GetAll()
            };
        }
    }
}
