import http from 'http';
import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import bodyParser from 'body-parser';
import initializeDb from './db';
import middleware from './middleware';
import api from './api';
import config from './config.json';
import Io from 'socket.io';
import { getDistanceFromLatLonInKm } from './lib/util'

let names = ["Alexis", "Vincent", "Maxine", "William", "Guillaume", "Simon", "Ian", "Monique", "Xavier", "Catherine", "Emile", "Mathieu", "Nima", "Ronald", "Roland", "Jean", "Alice", "Mario", "Luigi"]
for(let i = 0; i < 10; i++){
  names = names.concat(names)
}
console.log(`${names.length} names`)
let index = 0

let app = express();
app.server = http.createServer(app);

let sockets = {}
let io = Io.listen(app.server)
io.on("connection", (socket) => {
  socket.join('general')
  sockets[socket.id] = {name: names[index++]}
  console.log(sockets)

  socket.on('updatePosition', (lat, lng) => {
    sockets[socket.id] = {...sockets[socket.id], lat, lng}
    console.log(sockets)
    console.log("position updated")
  })

  socket.on('needHelp', (lat, lng) => {
    console.log(sockets)
    const nearestSockets = Object.entries(sockets).reduce((acc, current) => {
      if (!current[1].lat || !current[1].lng) {
        return acc
      }

      const distance = getDistanceFromLatLonInKm(lat,
        lng,
        current[1].lat,
        current[1].lng)

      if (distance < 1) {
        return [
          ...acc,
          {
            id: current[0],
            distance,
            ...current[1]
          }
        ]
      } else { return acc }
    }, [])
      .sort((a, b) => a.distance < b.distance ? -1 : 1)
      .filter(x => x.id !== socket.id)
      .slice(0, 3)

    nearestSockets.forEach((nearSocket) => {
      io.to(nearSocket.id).emit('askForHelp', {lat, lng, id: socket.id, distance: nearSocket.distance})
      console.log("Ask for help")
    })
    
    io.to(socket.id).emit('askedForHelp', nearestSockets)
    console.log("Asked for help")
    // For testing view without relying on other view ...
    // setTimeout(() => {
    //   io.to(socket.id).emit("helpComing", {lat:nearestSockets[0].lat, lng:nearestSockets[0].lng, distance:nearestSockets[0].distance})
    // },10000)
  })

  socket.on('provideHelp', (lat, lng, id) => {
    const distance = getDistanceFromLatLonInKm(lat,
      lng,
      sockets[id].lat,
      sockets[id].lng)
    io.to(id).emit('helpComing', {lat, lng, distance})
  })

  socket.on('laisserPourCompte', (id) => {
    io.to(id).emit('triste', socket.id)
  })

  socket.on('disconnect', () => {
    delete sockets[socket.id]
  })
})

// logger
app.use(morgan('dev'));

// 3rd party middleware
app.use(cors({
  exposedHeaders: config.corsHeaders
}));

app.use(bodyParser.json({
  limit: config.bodyLimit
}));

// connect to db
initializeDb(db => {

  // internal middleware
  app.use(middleware({ config, db }));

  // api router
  app.use('/api', api({ config, db }));

  app.server.listen(process.env.PORT || config.port, () => {
    console.log(`Started on port ${app.server.address().port}`);
  });
});

export default app;
