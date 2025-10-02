let id=location.search.split("=")[1];
document.getElementById("id").innerText=id;
let xhr=new XMLHttpRequest();
xhr.open("get",`https://68d18cfbe6c0cbeb39a530f3.mockapi.io/students/${id}`);
xhr.send();
xhr.onreadystatechange=function(){
    if(xhr.readyState==4){
        if(xhr.status==200){
        let data=JSON.parse(xhr.responseText);
        document.getElementById("FirstName").innerText=data.FirstName;
        document.getElementById("LastName").innerText=data.LastName;
        document.getElementById("city").innerText=data.city;

        }
    }
}