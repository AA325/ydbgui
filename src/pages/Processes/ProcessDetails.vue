<template>
  <div class="q-pa-md">
    <div style="padding:5px">
      <q-breadcrumbs gutter="xs">
        <q-breadcrumbs-el label="Home" />
        <q-breadcrumbs-el label="System Management" />
        <q-breadcrumbs-el label="Processes" />
        <q-breadcrumbs-el :label="'Process ' + $route.params.pid" />
      </q-breadcrumbs>
      <q-btn
        round
        style="margin-right:10px"
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
          Process does not exist or no longer alive!
        </span>
      </q-card-section>
    </q-card>
    <q-card v-if="processAlive">
      <q-tabs v-model="tab" dense class="bg-orange text-white shadow-2">
        <q-tab name="details" label="Process Details" />
        <q-tab name="variables" label="Variables" />
        <q-tab name="ivariables" label="Intrinsic Variables" />
      </q-tabs>
      <q-separator />

      <q-tab-panels v-model="tab" animated>
        <q-tab-panel name="details">
          <div class="text-h6 text-primary">
            Process {{ $route.params.pid }} Details
          </div>
          <pre
            style="max-height:calc(100vh - 302px)"
            v-html="processDetails.join('\n')"
          ></pre>
        </q-tab-panel>

        <q-tab-panel name="variables">
          <div class="text-h6 text-primary">
            Process {{ $route.params.pid }} Variables
          </div>
          <pre
            style="max-height:calc(100vh - 302px)"
            v-html="processVariables.join('\n')"
          ></pre>
        </q-tab-panel>

        <q-tab-panel name="ivariables">
          <div class="text-h6 text-primary">
            Process {{ $route.params.pid }} Intrinsic variables
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
