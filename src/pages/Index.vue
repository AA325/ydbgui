<template>
  <q-page>
    <div class="row flex flex-center q-pa-md" :style="'padding-top:50px'">
    <img
      alt="Quasar logo"
      src="~assets/YottaDB_logo.svg"
      style="max-width:35vw"
    >
    </div>
    <div class="row items-start q-gutter-md flex flex-center" style="padding-top:50px;">
     <q-card style="width:250px">
      <q-img
        src="https://cdn.quasar.dev/img/parallax2.jpg"
      />
      <q-card-actions>
        assssssssssssss
        <q-space />

        <q-btn
          color="grey"
          round
          flat
          dense
          :icon="expanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down'"
          @click="expanded = !expanded"
        />
      </q-card-actions>

      <q-slide-transition>
        <div v-show="expanded">
          <q-separator />
          <q-card-section class="text-subitle2">
            lorem
          </q-card-section>
        </div>
      </q-slide-transition>
    </q-card>

    
     </div>
  </q-page>
</template>

<script>
export default {
  name: 'PageIndex',
  data(){
    return {
      expanded:false
    }
  }
}
</script>
