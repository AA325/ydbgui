<template>
  <q-layout>
    <q-header
      elevated
      class="text-white"
      height-hint="61.59"
      :style="theme === 'light' ? 'background: #FA780A' : 'background: #3C176A'"
    >
      <q-toolbar class="q-py-sm q-px-md">
        <q-btn
          round
          dense
          flat
          :ripple="false"
          style="margin-right:10px"
          :to="'/'"
        >
          <q-avatar size="42px">
            <img
              src="~assets/logo.png"
              class="rotating"
              style="background-color:white;"
            />
          </q-avatar>
        </q-btn>

        <div
          class="GL__toolbar-link q-ml-xs q-gutter-md text-body2 text-weight-bold row items-center no-wrap"
        >
          <q-btn-dropdown flat label="System Administration" dense>
            <q-list>
              <q-item clickable v-close-popup :to="'/gde'">
                <q-item-section>
                  <q-item-label>Global Directory Editor (GDE)</q-item-label>
                </q-item-section>
              </q-item>
              <q-item clickable v-close-popup :to="'/globals'">
                <q-item-section>
                  <q-item-label>Globals</q-item-label>
                </q-item-section>
              </q-item>
              <q-item clickable v-close-popup :to="'/routines'">
                <q-item-section>
                  <q-item-label>Routines </q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </q-btn-dropdown>
          <q-btn-dropdown flat label="Utilities" dense>
            <q-list>
   
            </q-list>
          </q-btn-dropdown>
          <router-link to="/gde" class="text-white">
            DOCUMENTATION
          </router-link>
        </div>

        <q-space />

        <div class="q-pl-sm q-gutter-sm row items-center no-wrap">
          <q-select
            v-model="lang"
            :options="langOptions"
            dense
            borderless
            emit-value
            map-options
            options-dense
            style="width: 40px"
          />
          <q-btn
            dense
            flat
            round
            size="md"
            :icon="'settings'"
            @click="settingsDialog = true"
          />
          <q-btn
            dense
            flat
            round
            size="md"
            :icon="theme === 'light' ? 'wb_sunny' : 'nightlight_round'"
            @click="changeTheme"
          />
        </div>
      </q-toolbar>
    </q-header>
    <q-dialog v-model="settingsDialog" persistent>
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">Settings</div>
          <div>Change the settings below only if you'd like 
            to access the system management remotely or 
            thru the native app. Otherwise, please leave blank.
             All three fields have to be filled or left blank </div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input
            v-model="ip"
            outlined
            label="IP"
            :dense="true"
            hint="192.168.1.5"
            :rules="[
              val => ValidateIPaddress(val) || 'Please type a valid IP, or leave blank!'
            ]"
          />
        </q-card-section>
        <q-card-section class="q-pt-none">
          <q-input
            v-model="port"
            outlined
            label="Port"
            :dense="true"
            hint="8089"
            :rules="[
              val => (val === '' || parseInt(val)> 0 && parseInt(val) < 999999) || 'Please type a valid Port, or leave blank!'
            ]"
          />
        </q-card-section>
        <q-card-section class="q-pt-none">
          <q-select
            outlined
            :options="['http','https']"
            label="Protocol"
            v-model="protocol"
            :value="''"
            :dense="true"
            :hint="'http'"
          />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" color="warning" @click="settingsDialog = false" />
          <q-btn flat label="OK" @click="setSettings" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
export default {
  name: "MyLayout",
  data() {
    return {
      settingsDialog:false,
      ip: '',
      protocol:'',
      port:'',
      theme: "light",
      lang: this.$i18n.locale,
      langOptions: [
        { value: "en-us", label: "EN" },
        { value: "de", label: "DE" }
      ]
    };
  },
  created() {
    this.theme = this.$q.localStorage.getItem("ydb-app-theme") || "light";
    if (this.theme === "dark") {
      this.$q.dark.set(true);
    } else {
      this.$q.dark.set(false);
    }
    if (this.$q.localStorage.getItem('ydb-app-ip') 
       && this.$q.localStorage.getItem('ydb-app-port') 
       && this.$q.localStorage.getItem('ydb-app-protocol') 
    ){
      this.ip = this.$q.localStorage.getItem('ydb-app-ip') 
      this.port = this.$q.localStorage.getItem('ydb-app-port') 
      this.protocol = this.$q.localStorage.getItem('ydb-app-protocol') 
       let details = {
          ip: this.ip,
          port: this.port,
          protocol: this.protocol
        }
      this.$store.dispatch('app/setAppDetails', details)
    }
  },
  methods: {
    setSettings(){
      if (this.port && this.ip && this.protocol){
        let details = {
          ip: this.ip,
          port: this.port,
          protocol: this.protocol
        }
        this.$q.localStorage.set('ydb-app-ip', this.ip)
        this.$q.localStorage.set('ydb-app-port', this.port)
        this.$q.localStorage.set('ydb-app-protocol', this.protocol)
        this.$store.dispatch('app/setAppDetails', details)
      } else {
        this.port = '',
        this.protocol = '',
        this.ip = ''
        this.$q.localStorage.set('ydb-app-ip', '')
        this.$q.localStorage.set('ydb-app-port', '')
        this.$q.localStorage.set('ydb-app-protocol', '')
      }
      this.settingsDialog = false
      location.reload(true)
    },
    ValidateIPaddress(ipaddress) {
      if (ipaddress === "localhost" || ipaddress === "") {
        return true;
      } else if (
        /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(
          ipaddress
        )
      ) {
        return true;
      } else {
        return false;
      }
    },
    changeTheme() {
      if (this.theme === "light") {
        this.$q.dark.set(true);
        this.theme = "dark";
      } else {
        this.$q.dark.set(false);
        this.theme = "light";
      }
      this.$q.localStorage.set("ydb-app-theme", this.theme);
    }
  },
  watch: {
    lang(lang) {
      this.$i18n.locale = lang;
    }
  }
};
</script>

<style lang="sass">
.GL
  &__select-GL__menu-link
    .default-type
      visibility: hidden
    &:hover
      background: #0366d6
      color: white
      .q-item__section--side
        color: white
      .default-type
        visibility: visible
  &__toolbar-link
    a
      color: white
      text-decoration: none
      &:hover
        opacity: 0.7
  &__menu-link:hover
    background: #0366d6
    color: white
  &__menu-link-signed-in,
  &__menu-link-status
    &:hover
      & > div
        background: white !important
  &__menu-link-status
    color: $blue-grey-6
    &:hover
      color: $light-blue-9
  &__toolbar-select.q-field--focused
    width: 450px !important
    .q-field__append
      display: none
</style>
<style scoped>
.rotating {
  transition: transform 1s ease-in-out;
}
.rotating:hover {
  transform: rotateZ(360deg);
}
</style>
