namespace   Dashboard.Services
{
    public interface IService<T> where T : class
    {
        List<T> GetAll();
        T? GetById(int id);
        void Delete(T entity);
        void Add(T entity);
        void Update(T entity);
    }
}
