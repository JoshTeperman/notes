import { NOTIMP } from "dns";

// HTTP requests:

// NOTE:
// Ajax (Asynchronous JS and XML) is a technology concept and Axios is a promise based HTTP request library / client.
// AXIOS uses ‘Ajax’ technology since it creates XMLHttpRequests.
// Pros are using promises instead of callbacks, making HTTP requests from Node


fetch('url');
XMLHttpRequest('url');
$.get('url'); // requires JQUERY library

// AXIOS (npm package)
// make XMLHttpRequests from the browser


// USING AXIOS -->


axios.get('end-point')

// https://reqres.in/ <-- simulate express server and data

const axios = require('axios')
// import axios from 'axios'


============================================================
axios.get
============================================================

axios.get('end-point')
  .then((response) => {
    return response.data // <-- axios parses json for you, you have access to response body without calling .json()
  })

  .catch((error)=> {
    console.log(error.message)
  })

============================================================
axios.post
============================================================

axios.post('target-end-point', { newObjectName: name } )
const morpheus = {name: 'morpheus'}
axios.post('target-end-point', morpheus )
  .then((response) => {
    console.log(response.data)
  })


  
============================================================
axios.create // --> create a custom instance of axios (an api)
============================================================

const instance = axios.create({
  baseURL: 'https://some-domain.com/api/',
  timeout: 1000,
  headers: {'X-Custom-Header': 'foobar'}
});


// eg:

const api = axios.create({
  baseURL: 'http://localhost:7000'
})

export function getTickets() {
  return api.get('/')
    .then((res) => {
      return res.data
    })
    .catch((error) => {
      return error.message
    })
}

============================================================
Response Schema
============================================================


{
  // `data` is the response that was provided by the server
  data: {},

  // `status` is the HTTP status code from the server response
  status: 200,

  // `statusText` is the HTTP status message from the server response
  statusText: 'OK',

  // `headers` the headers that the server responded with
  // All header names are lower cased
  headers: {},

  // `config` is the config that was provided to `axios` for the request
  config: {},

  // `request` is the request that generated this response
  // It is the last ClientRequest instance in node.js (in redirects)
  // and an XMLHttpRequest instance the browser
  request: {}
}
When using then, you will receive the response as follows:

axios.get('/user/12345')
  .then(function (response) {
    console.log(response.data);
    console.log(response.status);
    console.log(response.statusText);
    console.log(response.headers);
    console.log(response.config);
  });


============================================================
Error Handling
============================================================

  axios.get('/user/12345')
  .catch(function (error) {
    if (error.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      console.log(error.response.data);
      console.log(error.response.status);
      console.log(error.response.headers);
    } else if (error.request) {
      // The request was made but no response was received
      // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
      // http.ClientRequest in node.js
      console.log(error.request);
    } else {
      // Something happened in setting up the request that triggered an Error
      console.log('Error', error.message);
    }
    console.log(error.config);
  });
You can define a custom HTTP status code error range using the validateStatus config option.

axios.get('/user/12345', {
  validateStatus: function (status) {
    return status < 500; // Reject only if the status code is greater than or equal to 500
  }
})