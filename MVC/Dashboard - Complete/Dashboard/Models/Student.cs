using System.ComponentModel.DataAnnotations;

namespace Dashboard.Models
{
    public class Student
    {
        public int StudentId { get; set; }

        [Required]
        public string FullName { get; set; }       
        public string Email { get; set; }         
        public string Phone { get; set; }          
        public DateTime? DateOfBirth { get; set; } 
        public string Gender { get; set; }    
        public int departmentId { get; set; }
        public Department department { get; set; }   
    }
}
