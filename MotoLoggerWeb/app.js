import { initializeApp } from "https://www.gstatic.com/firebasejs/11.0.1/firebase-app.js";
import { getDatabase, ref, onValue } from "https://www.gstatic.com/firebasejs/11.0.1/firebase-database.js";

const firebaseConfig = {
  apiKey: "AIzaSyAmdLPCful3iTjCbNnVKbFBC_Vk3pFSI9c",
  authDomain: "gps-logger-18c1c.firebaseapp.com",
  databaseURL: "https://gps-logger-18c1c-default-rtdb.firebaseio.com",
  projectId: "gps-logger-18c1c",
  storageBucket: "gps-logger-18c1c.appspot.com",
  messagingSenderId: "862941205688", // ←修正!!
  appId: "1:862941205688:web:b8795f7e810163fdbcd04d"
};

const app = initializeApp(firebaseConfig);
const db = getDatabase(app);

console.log("Firebase initialized successfully!");

const latRef = ref(db, "gps/lat");
const lonRef = ref(db, "gps/lon");
const speedRef = ref(db, "gps/speed");

onValue(latRef, snapshot => document.getElementById("lat").innerText = "Lat: " + snapshot.val());
onValue(lonRef, snapshot => document.getElementById("lon").innerText = "Lon: " + snapshot.val());
onValue(speedRef, snapshot => document.getElementById("speed").innerText = "Speed: " + snapshot.val());
