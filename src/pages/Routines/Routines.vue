<template>
  <div class="q-pa-md">
    <div style="padding:5px">
      <span class="text-center" style="font-size:28px;padding:25px">
        Routines
      </span>
    </div>
    <q-splitter v-model="splitterModel" style="height:88vh">
      <template v-slot:before>
        <div class="q-pa-md">
          <q-input
            filled
            bottom-slots
            v-model="searchRoutines"
            label="Search"
            :dense="true"
          >
            <template v-slot:append>
              <q-icon
                v-if="searchRoutines !== ''"
                name="close"
                @click="searchRoutines = ''"
                class="cursor-pointer"
              />
              <q-icon name="search" />
            </template>
          </q-input>
        </div>
        <div class="q-pa-md">
          <q-list style="height:88vh">
            <q-item>
              <q-item-section>
                <q-item-label>YDBWEB</q-item-label>
              </q-item-section>
              <q-item-section side top>
                <q-item-label caption>/home/aa/routines/</q-item-label>
              </q-item-section>
            </q-item>
            <q-separator inset />
          </q-list>
        </div>
      </template>

      <template v-slot:after>
          <codemirror
            ref="cmEditor"
            :value="code"
            :options="cmOptions"
            @ready="onCmReady"
            @focus="onCmFocus"
            @input="onCmCodeChange"
          />
      </template>
    </q-splitter>
  </div>
</template>
<script>
import { codemirror } from "vue-codemirror";
import 'codemirror/mode/mumps/mumps.js'

export default {
  name: "Routines",
  components: {
    codemirror
  },
  data() {
    return {
      splitterModel: 30,
      searchRoutines: "",
      code: "const a = 10",
      cmOptions: {
        tabSize: 4,
        mode: {
            name: 'mumps',
        },
        theme: this.$q.dark.isActive?'icecoder':'default',
        lineNumbers: true,
        line: true
      }
    };
  },
  methods: {
    onCmReady(cm) {
      console.log("the editor is readied!", cm);
    },
    onCmFocus(cm) {
      console.log("the editor is focused!", cm);
    },
    onCmCodeChange(newCode) {
      console.log("this is new code", newCode);
      this.code = newCode;
    }
  },
  computed: {
    codemirror() {
      return this.$refs.cmEditor.codemirror;
    },
    theme(){
        return this.$q.dark.isActive
    }
  },
  watch: {
    splitterModel(v) {
      this.$q.localStorage.set("ydb-routines-splitter", v);
    },
    theme(v){
        if (v){
            this.$set(this.cmOptions,'theme','icecoder')
        } else {
            this.$set(this.cmOptions,'theme','default')
        }
    }
  },
  created() {
    let splitterModel = this.$q.localStorage.getItem("ydb-routines-splitter");
    if (splitterModel) {
      this.splitterModel = splitterModel;
    }
  },
  async mounted() {
    let data = await this.$M("EXAMPLE^YDBWEBAPI");
    this.data = data.data;
    console.log("the current CodeMirror instance object:", this.codemirror);
  }
};
</script>
<style>
@import "../../../node_modules/codemirror/lib/codemirror.css";
@import "../../../node_modules/codemirror/theme/icecoder.css";
.CodeMirror {
  border: 1px solid #eee;
  height: 88vh;
}

</style>
