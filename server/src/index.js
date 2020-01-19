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

let app = express();
app.server = http.createServer(app);

let sockets = {}
let io = Io.listen(app.server)
io.on("connection", (socket) => {
  socket.join('general')
  sockets[socket.id] = {}

  socket.on('updatePosition', (lat, lng) => {
    sockets[socket.id] = {...socket[socket.id], lat, lng}
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
      io.to(nearSocket.id).emit('askForHelp', lat, lng, socket.id)
      console.log("Ask for help")
    })
    
    io.to(socket.id).emit('askedForHelp', nearestSockets)
    console.log("Asked for help")
  })

  socket.on('provideHelp', (lat, lng, id) => {
    io.to(id).emit('helpComing', lat, lng)
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
