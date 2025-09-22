const table = document.getElementById("table");
const xhr = new XMLHttpRequest();
xhr.open("GET","https://68d18cfbe6c0cbeb39a530f3.mockapi.io/students");
xhr.onreadystatechange =function(){
    if(xhr.readyState == 4){
        data = JSON.parse(xhr.responseText);
        for(item of data){
            table.innerHTML += 
            `<tr>
            <td>${item.id}</td>
             <td>
            <img src='${item.image}' width='70'>
            </td>
            <td>${item.FirstName}</td>
            <td>${item.LastName}</td>
            <td>${item.city}</td>
            </tr>` 
        }
    }  
}
xhr.send();


