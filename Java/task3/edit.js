const form = document.getElementById("form");
const message = document.getElementById("message");
let id = location.search.split("=")[1]; 

document.getElementById("displayId").innerText = id;
document.getElementById("studentId").value = id;

let xhr = new XMLHttpRequest();
xhr.open("get",`https://68d18cfbe6c0cbeb39a530f3.mockapi.io/students/${id}`);
xhr.onreadystatechange = function () {
  if (xhr.readyState == 4 ) {
    if(xhr.status == 200){
    let data = JSON.parse(xhr.responseText);
    document.getElementById("FirstName").value = data.FirstName;
    document.getElementById("LastName").value  = data.LastName;
    document.getElementById("city").value  = data.city;
  }}
};
xhr.send();

form.onsubmit = function (e) {
  e.preventDefault();
  let updatedStudent = {
    FirstName:  document.getElementById("FirstName").value,
    LastName:  document.getElementById("LastName").value,
    city: document.getElementById("city").value
  };

  let xhredit = new XMLHttpRequest();
  xhredit.open("PUT", `https://68d18cfbe6c0cbeb39a530f3.mockapi.io/students/${id}`);
  xhredit.setRequestHeader("Content-Type", "application/json");
  xhredit.onreadystatechange = function () {
    if (xhredit.readyState == 4) {
      if (xhredit.status == 200) {
        message.innerText="Student updated successfully";
        
      } else {
        message.innerText="Update failed";
      }
    }
  };
  xhredit.send(JSON.stringify(updatedStudent));
};