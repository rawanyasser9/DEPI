const form = document.getElementById("form");
const message = document.getElementById("message");

form.onsubmit=function(e){
e.preventDefault();
const data={
    FirstName:form.FirstName.value,
    LastName:form.LastName.value,
    city:form.city.value    
};
let xhr=new XMLHttpRequest();
xhr.open("POST","https://68d18cfbe6c0cbeb39a530f3.mockapi.io/students");
xhr.setRequestHeader("Content-Type", "application/json");
xhr.onreadystatechange=function(){
    if(xhr.readyState==4){
        if(xhr.status==201){
            message.innerText="created successfully";
            form.reset();
        }else{
            message.innerText="faild to create";
        }
    }
};
xhr.send(JSON.stringify(data));
};

