/*
	; Copyright (C) 2021 YottaDB, LLC
	; Author: Ahmed Abdelrazek
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version. ;
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details. ;
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <https://www.gnu.org/licenses/>. ;
	;
*/
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
