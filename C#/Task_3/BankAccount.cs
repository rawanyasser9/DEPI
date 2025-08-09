using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task_3
{
    public class BankAccount
    {
        public const string BankCode = "BNK001";
        public readonly DateTime CreatedDate;
        private int _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private double _balance;
        private static int AccountNumberCounter = 1000;
        public string FullName
        {
            get
            {
                return _fullName;
            }

            set
            {
                if (string.IsNullOrWhiteSpace(value) || string.IsNullOrEmpty(value))
                {
                    Console.WriteLine("invalid name");
                }
                else
                {
                    _fullName = value;
                }
            }

        }

        public string NationalId
        {
            get
            {
                return _nationalID;
            }
            set
            {
                if (IsValidNationalID(value))
                {
                    _nationalID = value;
                }
                else
                {
                    Console.WriteLine("invalid ID it must be  14 digits");
                }
            }
        }
        public double Balance
        {
            get
            {
                return _balance;
            }
            set
            {
                if (value >= 0)
                {
                    _balance = value;
                }
                else
                {
                    Console.WriteLine("invalid Balance it must be zero or positve");
                }
            }
        }
        public string PhoneNumber
        {
            get
            {
                return _phoneNumber;
            }
            set
            {
                if (IsValidPhoneNumber(value))
                {
                    _phoneNumber = value;
                }
                else
                {
                    Console.WriteLine("invalid phone number it must be start with 01 and be 11 digits long");
                }
            }
        }
        public string Address { get; set; } = "unknown";

        public BankAccount()
        {
            CreatedDate = DateTime.Now;
            _accountNumber = ++AccountNumberCounter;
            FullName = "Unknown";
            NationalId = "00000000000000";
            PhoneNumber = "01000000000";
            Address = "Unknown";
            Balance = 0;
        }
        public BankAccount(string fullname, string national_id, string phonenum, string address)
        {
            CreatedDate = DateTime.Now;
            _accountNumber = ++AccountNumberCounter;
            FullName = fullname;
            NationalId = national_id;
            PhoneNumber = phonenum;
            Address = address;
            Balance = 0;

        }
        public BankAccount(string fullname, string national_id, string phonenum, string address, double balance) : this(fullname, national_id, phonenum, address)
        {
            Balance = balance;
        }

      
        public virtual void ShowAccountDetails()
        {
            Console.WriteLine($"Name: {FullName}");
            Console.WriteLine($"Phone: {PhoneNumber}");
            Console.WriteLine($"balance: {Balance}");
            Console.WriteLine($"Address: {Address}");
            Console.WriteLine($"National ID: {NationalId}");
            Console.WriteLine($"Acc NUM: {_accountNumber}");
            Console.WriteLine($"BankCode: {BankCode}");
        }
        public bool IsValidNationalID(string id)
        {
            if (id.Length == 14 && id.All(char.IsDigit))
            {
                return true;
            }
            return false;
        }
        public bool IsValidPhoneNumber(string phone)
        {
            if ((phone[0] == '0' && phone[1] == '1') && phone.Length == 11 && phone.All(char.IsDigit))
            {
                return true;
            }
            return false;

        }
        public virtual decimal CalculateInterest() => 0;
      
    }
}
