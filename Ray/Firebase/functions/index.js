// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


// Saves a message to the Firebase Realtime Database but sanitizes the text by removing swearwords.
exports.addMessage = functions.https.onCall((data, context) => {
    const issue = data.issue;
    const uid = data.uid;
    const next_issueid = 123456789;

    const ref = '/Company/University%20Of%20Kent/Issues/' + next_issueid;

    return admin.database().ref(ref).push({
      issue: issue,
    }).then(() => {
     
      console.log('New Issue saved.');
      return { success: true };
    })
});

 // how to get issue id to save it in issues
 // after saving, how to we get issue id back? 
