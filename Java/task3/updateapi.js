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
            <td>
            <button class="delete" id="${item.id}" onclick="deleteStudent(this)">Delete</button>
            <a href="edit.html?id=${item.id}" class="edit" id="btn">Edit</a> 
             <a href="details.html?id=${item.id}"class="details"id="btn">Details</a>
            </td>
            </tr>` 
        }
    }  
}
xhr.send();
function deleteStudent(button){
    let id=button.id;
    let xhr= new XMLHttpRequest();
    xhr.open("Delete",`https://68d18cfbe6c0cbeb39a530f3.mockapi.io/students/${id}`);
    xhr.onreadystatechange=function(){
    if(xhr.readyState==4){
        if(xhr.status==200){
            button.closest("tr").remove();
            message.innerText="deleted";
        }else{
            message.innerText="faild to deleted";
        }
    }
}
xhr.send(); 
}



