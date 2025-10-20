using Microsoft.EntityFrameworkCore;
using Dashboard.Models;

namespace Dashboard.Repositories
{
    public class StudentRepository : GenericRepository<Student>, IStudentRepository
    {
        public StudentRepository(myContext db) : base(db)
        {
        }
        public bool EmailExists(string email)
        {
            return dbset.Any(s => s.Email == email);
        }

        public Student? GetByIdWithDept(int id)
        {
            return dbset.Include(s => s.department).FirstOrDefault(s => s.departmentId == id);
        }
    }
}
