using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;
using Task_3;

namespace Task_3
{
    internal class SavingAccount : BankAccount
    {
        private decimal _interestrate;
        public decimal InterestRate { get; set; }
        public SavingAccount(string fullname, string national_id, string phonenum, string address, double balance, decimal interestRate) : base(fullname, national_id, phonenum, address, balance)
        {
            InterestRate = interestRate;
        }
        public override decimal CalculateInterest()
        {
           return (decimal)Balance * InterestRate / 100;
        }
        
        
       
        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Interest : {InterestRate}%");

        }
     
    }
}
