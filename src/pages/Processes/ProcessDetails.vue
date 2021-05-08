<!--
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
-->
<template>
  <div class="q-pa-md">
    <div style="padding:5px">
      <q-breadcrumbs gutter="xs">
        <q-breadcrumbs-el  label="Home" />
        <q-breadcrumbs-el  label="System Management" />
        <q-breadcrumbs-el  label="Processes" />
        <q-breadcrumbs-el  :label="'Process ' + $route.params.pid" />
      </q-breadcrumbs>
      <q-btn
        round
        style="margin-right:10px"
        :class="$q.dark.isActive?'bg-orange':'bg-purple'"
        size="md"
        icon="arrow_back"
        :color="'primary'"
        @click="$router.push('/processes')"
      >
        <q-tooltip>
          Go Back
        </q-tooltip>
      </q-btn>
      <q-btn
        round
        style="margin-right:10px"
        size="md"
        icon="delete_forever"
        :color="'negative'"
        @click="killProcess"
      >
        <q-tooltip>
          Kill Process
        </q-tooltip>
      </q-btn>
    </div>
    <q-card v-if="!processAlive">
      <q-card-section>
        <span class="text-negative" style="font-size:26px;font-wight:700">
          Process details not available!
        </span>
      </q-card-section>
    </q-card>
    <q-card v-if="processAlive">
      <q-tabs v-model="tab" dense :class="$q.dark.isActive?'bg-orange text-white shadow-2':'bg-purple text-white shadow-2'">
        <q-tab name="details" label="Process Details" />
        <q-tab name="variables" label="Variables" />
        <q-tab name="ivariables" label="Intrinsic Variables" />
      </q-tabs>
      <q-separator />

      <q-tab-panels v-model="tab" animated>
        <q-tab-panel name="details">
          <div :class="$q.dark.isActive?'text-h6 text-orange':'text-h6 text-purple'">
            PID:{{ $route.params.pid }} Details
          </div>
          <pre
            style="max-height:calc(100vh - 302px)"
            v-html="processDetails.join('\n')"
          ></pre>
        </q-tab-panel>

        <q-tab-panel name="variables">
          <div :class="$q.dark.isActive?'text-h6 text-orange':'text-h6 text-purple'">
            PID:{{ $route.params.pid }} Variables
          </div>
          <pre
            style="max-height:calc(100vh - 302px)"
            v-html="processVariables.join('\n')"
          ></pre>
        </q-tab-panel>

        <q-tab-panel name="ivariables">
          <div :class="$q.dark.isActive?'text-h6 text-orange':'text-h6 text-purple'">
            PID:{{ $route.params.pid }} Intrinsic variables
          </div>
          <pre
            style="max-height:calc(100vh - 302px)"
            v-html="processIVariables.join('\n')"
          ></pre>
        </q-tab-panel>
      </q-tab-panels>
    </q-card>
  </div>
</template>
<script>
export default {
  name: "ProcessDetails",
  data() {
    return {
      tab: "details",
      processAlive: false,
      processDetails: [],
      processVariables: [],
      processIVariables: []
    };
  },
  async mounted() {
    let data = await this.$M("PROCESSDETAILS^%YDBWEBPRSC", {
      PID: this.$route.params.pid
    });
    if (data && data.STATUS) {
      this.processAlive = true;
      this.processDetails = data.DETAILS || [];
      this.processVariables = data.VARIABLES || [];
      this.processIVariables = data.IVARIABLES || [];
    } else {
      this.processAlive = false;
    }
  },
  methods: {
    async killProcess() {
      this.$q
        .dialog({
          title: "Confirm",
          message:
            "Are you sure you want to kill process " + this.$route.params.pid,
          cancel: true,
          persistent: true
        })
        .onOk(async () => {
          let data = await this.$M("KILLPROCESS^%YDBWEBPRSC", {
            PID: this.$route.params.pid
          });
          if (data && data.STATUS) {
            this.$q.notify({
              message: "Process Killed!",
              color: "positive"
            });
            this.$router.push("/processes");
          } else {
            this.$q.notify({
              message: "Process does not exist or no longer alive!",
              color: "negative"
            });
          }
        });
    }
  }
};
</script>
