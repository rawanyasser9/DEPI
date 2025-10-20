using Microsoft.EntityFrameworkCore;

namespace Dashboard.Models
{
    public class myContext:DbContext
    {
        public DbSet<Student> Students { get; set; }
        public DbSet<Department> Departments { get; set; }
        public myContext(DbContextOptions options) : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Student>().HasIndex(s => s.Email).IsUnique();
        }
    }
}
