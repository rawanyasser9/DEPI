using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task_3
{
    internal class CurrentAccount : BankAccount
    {
        private decimal _overdraftlimit;
        public decimal OverdraftLimit { get; set; }
        public CurrentAccount(string fullname, string national_id, string phonenum, string address, double balance, decimal overdraftlimit) : base(fullname, national_id, phonenum, address, balance)
        {
            OverdraftLimit = overdraftlimit;
        }

        public override decimal CalculateInterest()
        {
            return 0;
        }
        
        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Over draft Limit : {OverdraftLimit}");

        }
     
    }
}