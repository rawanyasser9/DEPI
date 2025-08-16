using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankTask
{
    public class CustomerAcc : Bank
    {
        private string _fullname;
        private int _accountnumber ;
        private string _ssn;
        private DateTime _dateofbirth;
        public static int idcounter = 0;
        private double _balance;
        private DateTime _dateopend;


        public double Balance
        {
            get
            {
                return _balance;
            }
            set
            {
                if (value < 0)
                {
                    Console.WriteLine ("Balance cannot be negative");
                }
                _balance = value;
            }

        }

        public int AccountNumber { get; set; }


        public CustomerAcc()
        {
             idcounter++;
            _accountnumber = idcounter;
            AccountNumber = _accountnumber;
            _dateopend =DateTime.Now;
            _balance = 0;
            _dateofbirth = DateTime.Now;
            _fullname = string.Empty;
            _ssn = string.Empty;

        }
        public CustomerAcc(string name, string code ,string fullname, string ssn, double balance,DateTime birth ):base(name,code)
        {
            _dateopend = DateTime.Now;
            idcounter++;
            _accountnumber = idcounter;
            AccountNumber= _accountnumber;
            _ssn = ssn;
            _balance = balance;
            _fullname = fullname;
            _dateofbirth = birth;
        }
        public string FullName {
            get
            {
                return _fullname;
            }
            set
            {
                if (string.IsNullOrWhiteSpace(value) || string.IsNullOrEmpty(value))
                {
                    Console.WriteLine("invalid name");
                }
                else
                {
                    _fullname = value;
                }
            }
        }
        public string SSN {
            get
            {
                return _ssn;
            }
            set
            {
                if (value.Length == 14)
                {
                    _ssn = value;
                }
                else
                {
                    Console.WriteLine("invalid ID it must be  14 digits");
                }
            }
        }
        public DateTime  DateOfBirth { get; set; }

        public void update_name (string name)
        {

            if (string.IsNullOrWhiteSpace(name) )
            {
                Console.WriteLine("invalid name");
            }
            else
            {
                _fullname = name;
            }
        }

        
        public void Deposit(double money)
        {
            if (money >= 0)
            {
                _balance += money;
            }
            else
            {
                Console.WriteLine("invalid money");
            }
        }
        public void Withdrawing(double money)
        {
            if (Balance >= money)
            {
                Balance -= money;
            }
            else
            {
                Console.WriteLine("Withdrawing money is more than current balance ");
            }
        }


        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Name: {FullName}");
            Console.WriteLine($"balance: {Balance}");
            Console.WriteLine($"National ID: {SSN}");
            Console.WriteLine($"Acc NUM: {AccountNumber}");
            Console.WriteLine($"Date Opend: {_dateopend}");
            Console.WriteLine($"Date of birth : {DateOfBirth}");

        }

        public virtual double CalculateInterest() => 0;



    }
}
