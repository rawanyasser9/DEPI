using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;


namespace BankTask
{
    public class Current_account: CustomerAcc
    {
        public double OverdraftLimit { get; set; }

        public Current_account(string bankName, string bankCode, string fullname, string ssn, double balance, DateTime birth, double overlimit) : base(bankName, bankCode, fullname, ssn, balance, birth)
        {

            OverdraftLimit = overlimit;
        }
     
        public override double CalculateInterest()
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
