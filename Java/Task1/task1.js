let fontSize = 16;
let imgWidth = 100; 
let imgHeight = 100;
const outputBox = document.getElementById("outputBox");
const name = document.getElementById("name");
const imgInput = document.getElementById("img");
const welcome = document.getElementById("welcome");
const imgBox = document.getElementById("imgBox");
const plusBtn = document.getElementById("plus");
const minusBtn = document.getElementById("minus");
const clickBtn = document.getElementById("click");
const imgPlusBtn = document.getElementById("imgplus");
const fontsSelect = document.getElementById("fonts");

clickBtn.onclick = function() {
    const nameValue = name.value.trim();
    if (nameValue !== "") {
        welcome.innerText = `welcome ${nameValue}`;
    } else {
        welcome.innerText = `welcome guest`;
    }
    welcome.style.fontSize = `${fontSize}px`;
    welcome.style.fontFamily = fontsSelect.value;

    const imgValue = imgInput.value;
    if (validImg(imgValue)) {
        imgBox.innerHTML = `<img id="myImg" src="${imgValue}" width="${imgWidth}" height="${imgHeight}">`;
    } else {
        imgBox.innerHTML = "";
    }
};

function validImg(imgval) {
const arr=imgval.split(".");
const ext=arr[arr.length-1];
    return ext === "jpg" || ext === "png";
}

plusBtn.onclick = function() {
    if (fontSize < 40) {
        fontSize += 2;
        welcome.style.fontSize = `${fontSize}px`;
    }
};

minusBtn.onclick = function() {
    if (fontSize > 10) {
        fontSize -= 2;
        welcome.style.fontSize = `${fontSize}px`;
    }
};

imgPlusBtn.onclick = function() {
    const img = document.getElementById("myImg");
    if ( validImg(imgInput.value)) {
        const boxWidth = imgBox.clientWidth;
        const boxHeight = imgBox.clientHeight;
        const newWidth = imgWidth + 20;
        const newHeight = imgHeight + 20;

        if (newWidth <= boxWidth && newHeight <= boxHeight) {
            imgWidth = newWidth;
            imgHeight = newHeight;
            img.style.width = `${imgWidth}px`;
            img.style.height = `${imgHeight}px`;
        } else {
            alert("The image cannot be enlarged beyond the borders of the box");
        }
    }
};

fontsSelect.onchange = function() {
    welcome.style.fontFamily = fontsSelect.value;
};