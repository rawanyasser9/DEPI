using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankTask
{
    public class Bank 
    {
        public List<CustomerAcc> CustomersAcc { get; set; } = new List<CustomerAcc>();


        public string Name { get; set; }
        public string BranchCode { get; set; }

        public Bank()
        {
            Name = "Default Bank";
            BranchCode = "0000";
        }

        public Bank(string name, string branchCode)
        {
            Name = name;
            BranchCode = branchCode;
        }


        public void AddCustomer(CustomerAcc customeracc)
        {
            CustomersAcc.Add(customeracc);
        }

        public void ShowReport()
        {
            Console.WriteLine($"Bank: {Name} (Branch {BranchCode})");
            foreach (CustomerAcc customer in CustomersAcc)
            {
                Console.WriteLine($"Customer {customer.Name}:");

                Console.WriteLine($" - Account {customer.AccountNumber}, Balance: {customer.Balance}");

            }
        }

        public virtual void ShowAccountDetails()
        {
            Console.WriteLine($"Bank Name : {Name}");
            Console.WriteLine($"Bank Code: {BranchCode}");
        }


    }


}

