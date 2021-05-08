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
import axios from 'axios'
import createStore from '../store/index'
import Vue from 'vue'

export default async (routine, data) => {
  const store = typeof createStore === 'function'
    ? createStore({ Vue })
    : createStore
  try {
    // store.dispatch('app/setAjaxLoading', true)
    let endPoint = ''
    if ( store.state.app.details.ip
      && store.state.app.details.port
      && store.state.app.details.protocol
      ) {
        endPoint = `${store.state.app.details.protocol}://${store.state.app.details.ip}:${store.state.app.details.port}`
      }
    const result = await axios({
      url: endPoint+'/ydbwebapi',
      method: 'post',
      data: { routine, data }
    })
    /*
    if (result.data.FUZDialog && result.data.FUZDialog.status === true && result.data.FUZDialog.props) {
      Dialog.create({
        component: FUZDialog,
        // persistent: true...
        ok: false,
        cancel: false,
        ...result.data.FUZDialog.props
      }).onOk(() => {
      }).onCancel(() => {
      }).onDismiss(() => {
      })
    }
    if (result.data.dispatch) {
      await store.dispatch(result.data.dispatch.action, result.data.dispatch.data)
    }
    if (result.data.auth_status === false) {
      store.dispatch('app/setAjaxLoading', false)
      LocalStorage.set('sessionDetails', undefined)
      LocalStorage.set('appDetails', undefined)
      store.dispatch('app/logOut', false)
      return {}
    } else {
      store.dispatch('app/setAjaxLoading', false)
      return result.data && result.data.data
    }
    */
    return result.data && result.data.data
  } catch (e) {
    console.log(e)
    /*
    store.dispatch('app/setAjaxLoading', false)
    Dialog.create({
      component: FUZDialog,
      // persistent: true,
      ok: false,
      cancel: false,
      iconPath: 'Warning',
      iconWidth: 150,
      iconHeight: 150,
      message: e.message,
      buttons: {
        ok: true
      }
    }).onOk(() => {
    }).onCancel(() => {
    }).onDismiss(() => {
    })
    */
  }
}
