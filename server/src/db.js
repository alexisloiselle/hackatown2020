import data from './data/bornes'

export default callback => {
  // connect to a database if needed, then pass it to `callback`:
	callback(data);
}
