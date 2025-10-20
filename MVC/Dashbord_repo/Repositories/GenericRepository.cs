
using Dashboard.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Dashboard.Repositories
{
    public class GenericRepository<T> : IRepository<T> where T : class
    {
        protected myContext db;
        protected DbSet<T> dbset;
        public GenericRepository(myContext _context) 
        {
            db = _context;
            dbset = db.Set<T>();
        }
        public void Add(T entity)
        {
            dbset.Add(entity);
        }

        public void Delete(T entity)
        {
            dbset.Remove(entity);
        }

        public List<T> GetAll()
        {
            return dbset.ToList();
        }

        public T? GetById(int id)
        {
            return dbset.Find(id);
        }

        public void Save()
        {
            db.SaveChanges();
        }

        public void Update(T entity)
        {
            dbset.Update(entity);
        }
    }
}
