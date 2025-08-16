using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace BankTask
{
    public class Savings_account : CustomerAcc
    {
        public double InterestRate { get; set; }

        public Savings_account(string bankName, string bankCode, string fullname, string ssn, double balance, DateTime birth, double interestrate)
              : base(bankName, bankCode, fullname, ssn, balance, birth)
        {

            InterestRate = interestrate;
        }

        public override double CalculateInterest()
        {
            return  Balance * InterestRate / 100;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Interest : {InterestRate}%");

        }
    }

}
