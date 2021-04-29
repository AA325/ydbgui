<template>
  <q-page>
    <div class="row flex flex-center q-pa-md" :style="'padding-top:50px'">
      <img
        v-if="!$q.dark.isActive"
        alt="Quasar logo"
        src="~assets/YottaDB_logo-light.svg"
        style="max-width:35vw"
      />
      <img
        v-if="$q.dark.isActive"
        alt="Quasar logo"
        src="~assets/YottaDB_logo-dark.svg"
        style="max-width:35vw"
      />
    </div>
    <div
      class="row items-start q-gutter-md flex flex-center"
      style="padding-top:50px;"
    >
      <q-card style="width:250px">
        <q-img src="~assets/uc-1.png" />
        <q-card-actions>
          <span style="font-size:18px;font-weight:700;">System Management</span>
          <q-space />

          <q-btn
            color="grey"
            round
            flat
            dense
            :icon="
              expandedSystemManagement
                ? 'keyboard_arrow_up'
                : 'keyboard_arrow_down'
            "
            @click="expandedSystemManagement = !expandedSystemManagement"
          />
        </q-card-actions>

        <q-slide-transition>
          <div v-show="expandedSystemManagement">
            <q-item clickable :to="'/gde'" dense>
              <span style="font-size:16px">
                Global Directory Editor (GDE)
              </span>
            </q-item>
          </div>
        </q-slide-transition>
      </q-card>

      <q-card style="width:250px">
        <q-img src="~assets/uc-2.png" />
        <q-card-actions>
          <span style="font-size:18px;font-weight:700;">System Explorer</span>
          <q-space />

          <q-btn
            color="grey"
            round
            flat
            dense
            :icon="
              expandedSystemExplorer
                ? 'keyboard_arrow_up'
                : 'keyboard_arrow_down'
            "
            @click="expandedSystemExplorer = !expandedSystemExplorer"
          />
        </q-card-actions>

        <q-slide-transition>
          <div v-show="expandedSystemExplorer">
            <q-item clickable :to="'/routines'" dense>
              <span style="font-size:16px">
                Routines
              </span>
            </q-item>
            <q-item clickable :to="'/globals'" dense>
              <span style="font-size:16px">
                Globals
              </span>
            </q-item>
          </div>
        </q-slide-transition>
      </q-card>
      <q-card style="width:250px">
        <q-img src="~assets/uc-4.png" />
        <q-card-actions>
          <span style="font-size:18px;font-weight:700;">Utilities</span>
          <q-space />

          <q-btn
            color="grey"
            round
            flat
            dense
            :icon="
              expandedUtilities
                ? 'keyboard_arrow_up'
                : 'keyboard_arrow_down'
            "
            @click="expandedUtilities = !expandedUtilities"
          />
        </q-card-actions>

        <q-slide-transition>
          <div v-show="expandedUtilities">
          </div>
        </q-slide-transition>
      </q-card>
            <q-card style="width:250px">
        <q-img src="~assets/uc-6.png" />
        <q-card-actions>
          <span style="font-size:18px;font-weight:700;">Documentation</span>
          <q-space />
          <q-btn
            color="grey"
            round
            flat
            dense
            :icon="
              expandedDocumentation
                ? 'keyboard_arrow_up'
                : 'keyboard_arrow_down'
            "
            @click="expandedDocumentation = !expandedDocumentation"
          />
        </q-card-actions>

        <q-slide-transition>
          <div v-show="expandedDocumentation">
          </div>
        </q-slide-transition>
      </q-card>
    </div>
  </q-page>
</template>

<script>
export default {
  name: "PageIndex",
  data() {
    return {
      expandedSystemManagement: false,
      expandedSystemExplorer: false,
      expandedUtilities: false,
      expandedDocumentation: false
    };
  }
};
</script>
