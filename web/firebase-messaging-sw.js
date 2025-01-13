importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging.js');

// Initialize Firebase
firebase.initializeApp({
  apiKey: 'AIzaSyArMkO4lcFsl8lWxChwyXPNee5gtfoMy8U',
  appId: '1:68892861323:web:6934554389673ba24f458e',
  messagingSenderId: '68892861323',
  projectId: 'notificatios-web',
  authDomain: 'notificatios-web.firebaseapp.com',
  storageBucket: 'notificatios-web.firebasestorage.app',
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: payload.notification.icon, // يمكنك تخصيص أيقونة الإشعار هنا
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Register service worker
if ('serviceWorker' in navigator) {
  navigator.serviceWorker
    .register('firebase-messaging-sw.js') // تأكد من أن المسار صحيح
    .then(function(registration) {
      console.log('Service worker registration successful, scope is:', registration.scope);
    })
    .catch(function(err) {
      console.log('Service worker registration failed, error:', err);
    });
}
