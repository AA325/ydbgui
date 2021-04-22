<template>
  <q-layout>
    <q-header
      elevated
      class="text-white"
      height-hint="61.59"
      :style="theme==='light'?'background: #FA780A':'background: #3C176A'"
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
            <q-item-label>Globals Editor</q-item-label>
          </q-item-section>
        </q-item>
           <q-item clickable v-close-popup :to="'/routines'">
          <q-item-section>
            <q-item-label>Routines Editor</q-item-label>
          </q-item-section>
        </q-item>

      </q-list>
    </q-btn-dropdown>
       <q-btn-dropdown flat label="Utilities" dense>
      <q-list>
        <q-item clickable v-close-popup :to="'/gde'">
          <q-item-section>
            <q-item-label>Global Directory Editor (GDE)</q-item-label>
          </q-item-section>
        </q-item>
        <q-item clickable v-close-popup :to="'/globals'">
          <q-item-section>
            <q-item-label>Globals Viewer and Editor</q-item-label>
          </q-item-section>
        </q-item>
           <q-item clickable v-close-popup :to="'/routines'">
          <q-item-section>
            <q-item-label>Routines Viewer and Editor</q-item-label>
          </q-item-section>
        </q-item>

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
            :icon="theme === 'light' ? 'wb_sunny' : 'nightlight_round'"
            @click="changeTheme"
          />
        </div>
      </q-toolbar>
    </q-header>

    <q-page-container style="max-width:1920px;margin:0 auto">
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
export default {
  name: "MyLayout",
  data() {
    return {
      theme: "light",
      lang: this.$i18n.locale,
      langOptions: [
        { value: 'en-us', label: 'EN' },
        { value: 'de', label: 'DE' }
      ]
    };
  },
  methods: {
    changeTheme() {
      if (this.theme === "light") {
        this.$q.dark.set(true);
        this.theme = "dark";
      } else {
        this.$q.dark.set(false);
        this.theme = "light";
      }
    }
  },
    watch: {
    lang(lang) {
      this.$i18n.locale = lang
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
