namespace Dashboard.Repositories
{
    public interface IRepository<T> where T : class 
    {
  
        void Add(T entity);
       
        List<T> GetAll();

        T? GetById(int id);

        void Update(T entity);

        void Delete(T entity);
        void Save();
    }
}
