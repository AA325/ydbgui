import Vue from 'vue'
export function setAppDetails ( state, val ) {
    Vue.set(state, 'details', Object.freeze(val))
}
