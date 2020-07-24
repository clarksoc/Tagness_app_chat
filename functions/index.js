const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
  .document('messages/{groupId1}/{groupId2}/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const fromId = doc.fromId
    const toId = doc.toId
    const contentMessage = doc.content
    const holderName = doc.holderName

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('id', '==', toId)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          console.log(`Found user to: ${userTo.data().username}`)
          if (userTo.data().pushToken && userTo.data().chattingWith !== fromId) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('id', '==', fromId)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                  console.log(`Found user from: ${userFrom.data().username}`)
                  const payload = {
                    notification: {
                      title: `You have a message from "${userFrom.data().username}"`,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default'
                    },
                    data: {
                      id: String(userFrom.data().id),
                      click_action: "FLUTTER_NOTIFICATION_CLICK",
                      name: String(userFrom.data().username),
                      photo_url: String(userFrom.data().photoUrl),
                      holderName: holderName,
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          } else {
            console.log('Can not find pushToken target user')
          }
        })
      })
    return null
  })