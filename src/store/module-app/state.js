import { LocalStorage } from 'quasar'
export default function () {
  return {
    details:{
      port: LocalStorage.getItem('ydp-app-port') || '',
      protocol: LocalStorage.getItem('ydp-app-protocol') || '',
      ip: LocalStorage.getItem('ydp-app-ip') || '',
    }
  }
}
