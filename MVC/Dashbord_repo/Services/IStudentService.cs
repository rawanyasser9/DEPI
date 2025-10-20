using Dashboard.Models;

namespace Dashboard.Services
{
    public interface IStudentService : IService<Student>
    {
        Student? GetByIdWithDept(int id);
        bool EmailExists(string email);
        StudentCreateViewModel GetStudentCreateViewModel(Student? std = null);
    }
}
