

var config = {
    apiKey: "AIzaSyBwOdqqemBPcNzzUfCpOMWeKC__su3XDuM",
    authDomain: "reportingray-ddd38.firebaseapp.com",
    databaseURL: "https://reportingray-ddd38.firebaseio.com",
    projectId: "reportingray-ddd38",
    storageBucket: "reportingray-ddd38.appspot.com",
    messagingSenderId: "616911142042"
};
firebase.initializeApp(config);

const report = document.getElementById("reportNumber");
const reportNumber = window.location.hash.slice(1);
const hash = window.location.hash;
report.innerHTML = "Issue Report: " + reportNumber;

const dbRef = firebase.database().ref();
const usersRef = dbRef.child('Company').child('University Of Kent');

const userName = document.getElementById("name");
const userEmail = document.getElementById("email");
const userPhone = document.getElementById("phone");
const building = document.getElementById("building");
const floor = document.getElementById("floor");
const room = document.getElementById("room");
const natureOfIssue = document.getElementById("natureOfIssue");
const description = document.getElementById("description");
const confirmation = document.getElementById("confirmation");

const attachments = document.getElementById("attachments");

const location_content = document.getElementById("location_content");

usersRef.on("value", function (snapshot) {
    var userNumber = snapshot.numChildren();
    userNumber += 1;
    findUser(userNumber);
});

function findUser(userNumber) {
    for (var i = 0; i < userNumber; i++) {
        usersRef.child('User').child('User ID').child(i).child('issues').on("value", function (snapshot) {
            snapshot.forEach(function (data) {
                if (data.val() == reportNumber) {
                    // i = user id
                    findUserDetails(i);
                    
                    findIssueDetails();
                    findAttachments();
                }
            });
        });
    }
}

function findUserDetails(i) {
    usersRef.child('User').child('User ID').child(i).on("value", function (snapshot) {
        userName.innerHTML = "<b>Name: </b> " + snapshot.child('name').val();
        userEmail.innerHTML = "<b>Email: </b> " + snapshot.child('email').val();
        userPhone.innerHTML = "<b>Phone Number: </b> " + snapshot.child('phone').val();
    });
}

function findIssueDetails() {
    usersRef.child('Issues').child(reportNumber).on("value", function (snapshot) {
        natureOfIssue.innerHTML = "<b>Nature Of Issue: </b> " + snapshot.child('issue_title').val();
        description.innerHTML = "<b>Description: </b> " + snapshot.child('description').val();
    });
    usersRef.child('Issues').child(reportNumber).child('location').on("value", function (snapshot) {
        if (snapshot.child('building').val() == null){
            location_content.innerHTML = "<iframe width='100%' height='500px' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='https://maps.google.com/maps?q="+snapshot.child('lat').val()+","+snapshot.child('long').val()+"&hl=es;z=14&amp;output=embed'></iframe>";
        }
        else{
        building.innerHTML = "<b>Building: </b> " + snapshot.child('building').val();
        floor.innerHTML = "<b>Floor: </b> " + snapshot.child('floor').val();
        room.innerHTML = "<b>Room: </b> " + snapshot.child('room').val();
    }
    });
    
    
}

function findAttachments(){
    usersRef.child('Issues').child(reportNumber).child('attachments').on("value", function (snapshot) {
        if(snapshot.numChildren()==1){
            attachments.innerHTML = "<div style='padding-top: 70px; margin-top: -70px;'></div><h3>Attachments</h3><div id='images' class='row'><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('0').val()+"/></div></div>"
        }
        else if(snapshot.numChildren()==2){
            attachments.innerHTML = "<div style='padding-top: 70px; margin-top: -70px;'></div><h3>Attachments</h3><div id='images' class='row'><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('0').val()+" /></div><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('1').val()+" /></div></div>"
        }
        else if(snapshot.numChildren()==3){
            attachments.innerHTML = "<div style='padding-top: 70px; margin-top: -70px;'></div><h3>Attachments</h3><div id='images' class='row'><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('0').val()+" /></div><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('1').val()+" /></div><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('2').val()+" /></div></div>"
        }
        else if(snapshot.numChildren()==4){
            attachments.innerHTML = "<div style='padding-top: 70px; margin-top: -70px;'></div><h3>Attachments</h3><div id='images' class='row'><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('1').val()+" /></div><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('1').val()+" /></div><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('2').val()+" /></div><div class='column'><img class='image-column' alt='Added attachments' src="+snapshot.child('3').val()+" /></div></div>"
        }
        
    });
}

function confirmationMessage() {
    usersRef.child('Issues').child(reportNumber).update({
    confirmation : "true"
  });
        alert("User Confirmation Sent.");
    confirmation.style.backgroundColor = "#859FAA";
        confirmation.style.cursor = "not-allowed";
    confirmation.disabled = true;
}

function contactScroll() {
  var elmnt = document.getElementById("contact");
  elmnt.scrollIntoView();
}

function locationScroll() {
  var elmnt = document.getElementById("location");
  elmnt.scrollIntoView();
}

function homeScroll() {
document.body.scrollTop = document.documentElement.scrollTop = 0;
}

function issueScroll() {
  var elmnt = document.getElementById("issue");
  elmnt.scrollIntoView();
}

function attachmentsScroll() {
  var elmnt = document.getElementById("attachments");
  elmnt.scrollIntoView();
}

