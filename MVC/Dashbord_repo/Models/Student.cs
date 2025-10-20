using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Dashboard.Models
{
    public class Student
    {
        public int StudentId { get; set; }
        [Required(ErrorMessage = "please enter student name")]
        [MinLength(3)]
        [MaxLength(50)]
        public string FullName { get; set; }
        [Required]
        [EmailAddress]
        [Remote("CheckEmail", "Student", ErrorMessage = "email already exists")]
        public string Email { get; set; }
        [RegularExpression(@"^(010|011|012|015)[0-9]{8}$")]
        public string Phone { get; set; }          
        public DateTime? DateOfBirth { get; set; } 
        public string Gender { get; set; }    
        public int departmentId { get; set; }
        public Department department { get; set; }   
    }
}
