using Dashboard.Models;

namespace Dashboard.Repositories
{
    public interface IStudentRepository : IRepository<Student>
    {
        bool EmailExists(string email);
        Student? GetByIdWithDept(int id);
    }
}
