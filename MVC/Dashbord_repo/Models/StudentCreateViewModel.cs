namespace Dashboard.Models
{
    public class StudentCreateViewModel
    {
        public Student student { get; set; } = new Student();
        public List<Department> departments { get; set; } = new List<Department>();
    }
}
