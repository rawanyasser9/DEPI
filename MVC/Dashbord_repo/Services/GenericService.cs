
using Dashboard.Repositories;

namespace Dashboard.Services
{
    public class GenericService<T> : IService<T> where T : class
    {
        protected IRepository<T> repository;
        public GenericService(IRepository<T> _repository)
        {
            repository = _repository;
        }
        public void Add(T entity)
        {
            repository.Add(entity);
            repository.Save();
        }

        public void Delete(T entity)
        {
            repository.Delete(entity);
            repository.Save();
        }

        public List<T> GetAll()
        {
            return repository.GetAll();
        }

        public T? GetById(int id)
        {
            return repository.GetById(id);
        }

        public void Update(T entity)
        {
            repository.Update(entity);
            repository.Save();
        }
    }
}
