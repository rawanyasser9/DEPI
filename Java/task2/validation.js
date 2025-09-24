
const form = document.getElementById("form");
const errors = document.getElementsByClassName("msg-error");

function clearErrors() {
    for (let item of errors) {
        item.innerText = "";
    }
}
function displayError(eleId, msg, color = "red") {
    document.getElementById(eleId).innerText = msg;
    document.getElementById(eleId).style.color = color;
}


form.onsubmit = function(e) {
    clearErrors();
    var isValid = true;

    if (form['name'].value == '') {
        displayError( "name-error", "name is required");
        isValid = false;
    } else if (!/^[a-zA-Z ]{3,20}$/.test(form['name'].value)) {
        displayError("name-error", "invalid name");
        isValid = false;
    }
   

    if (form['email'].value == "") {
        displayError( "email-error", "email is required");
        isValid = false;
    } else if (!/^[a-zA-Z]+[0-9._]+@[a-z]+\.[a-z]{2,}/.test(form['email'].value)) {
        displayError("email-error", "invalid email");
        isValid = false;
    }

    if (form['password'].value == "") {
        displayError("password-error", "password is required");
        isValid = false;
    } else if (!/^[a-zA-Z0-9!@#$%^&*]{8,}$/.test(form['password'].value)) {
        displayError("password-error", "password must be at least 8 chars with letters, numbers, or special chars");
        isValid = false;
    }

    if (form['confirm-password'].value == "") {
        displayError( "confirm-password-error", "confirm password is required");
        isValid = false;
    } else if (form['confirm-password'].value != form['password'].value) {
        displayError( "confirm-password-error", "passwords do not match");
        isValid = false;
    }

    const phoneValue = form['phone'].value.trim();
    if (phoneValue !== "" && !/^01[0-9]{9}$/.test(phoneValue)) {
        displayError("phone-error", "invalid phone number");
        isValid = false;
    }

    const fileInput = form['image'];
    if (fileInput.files.length > 0) {
        const fileName = fileInput.value.split('.');
        if (fileName[1] !== 'png' && fileName[1] !== 'jpg') {
            displayError( "image-error", "only PNG or JPG images allowed");
            isValid = false;
        }
    }

     return isValid;
}

form['name'].onblur = function() {
    if (this.value == "") {
        displayError( "name-error", "name is required");
    } else if (!/^[a-zA-Z ]{3,20}$/.test(this.value)) {
        displayError( "name-error", "invalid name");
    } else {
        displayError( "name-error", "valid name", "green");
    }
}

form['email'].onblur = function() {
    if (this.value == "") {
        displayError("email-error", "email is required");
    } else if (!/^[a-zA-Z0-9._]+@[a-z]+\.[a-z]{2,}/.test(this.value)) {
        displayError( "email-error", "invalid email");
    } else {
        displayError("email-error", "valid email", "green");
    }
}

