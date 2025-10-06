using Microsoft.EntityFrameworkCore;

namespace Dashboard.Models
{
    public class myContext:DbContext
    {
        public DbSet<Student> Students { get; set; }
        public DbSet<Department> Departments { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured) 
            {
                optionsBuilder.UseSqlServer("Server=DESKTOP-UEP809I\\SQLEXPRESS;Database=DashboardDB;Trusted_Connection=True;TrustServerCertificate=True;");
            }
        }
    }
}
