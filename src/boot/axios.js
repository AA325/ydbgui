import Vue from 'vue'
import axios from 'axios'
// axios.defaults.timeout = 10000


axios.interceptors.request.use(x => {
  if (process.env.DEV){
  x.meta = x.meta || {}
  x.meta.requestStartedAt = new Date().getTime()
  }
  return x
})

axios.interceptors.response.use(x => {
  if (x.config.data && process.env.DEV){
    console.log('*******************************************************************************************************')
    console.log(`Request =>  ${JSON.stringify(JSON.parse(x.config.data), null, 4)} - ${new Date().getTime() - x.config.meta.requestStartedAt} ms`)
    console.log('Result =>', x.data)
  }
  return x
}
)

Vue.prototype.$axios = axios
