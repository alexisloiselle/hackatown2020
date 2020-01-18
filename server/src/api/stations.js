import { Router } from 'express';
import { getDistanceFromLatLonInKm } from '../lib/util'

export default db => {
  const routes = Router();

  routes.get('/', (req, res, next) => {
    res.json(Object.values(db).slice(0, 5))
  })

  routes.post('/', (req, res, next) => {
    const count = req.body.count || 3

    if (!req.body.lat || !req.body.lng) {
      res.status(400).send("Need lat and lng")
    }

    const nearest = Object.values(db)
      .reduce((acc, current) => {
        const distance = getDistanceFromLatLonInKm(req.body.lat,
          req.body.lng,
          current.lat,
          current.lng)

        if (distance < 1) {
          return [
            ...acc,
            {
              distance,
              ...current
            }
          ]
        } else { return acc }
      }, [])
      .sort((a, b) => a.distance < b.distance ? -1 : 1)
      .slice(0, count)

    res.json(nearest)
  })

  return routes;
}