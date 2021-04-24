<template>
  <div class="q-pa-md" id="routinesDiv">
    <div style="padding:5px">
      <span class="text-center" style="font-size:28px;padding:25px">
        Routines
      </span>
    </div>
    <q-splitter
      v-model="splitterModel"
      style="height:88vh"
      v-if="!loading && !loadingDialog"
    >
      <template v-slot:before>
        <q-infinite-scroll
          @load="loadMoreRoutines"
          :offset="0"
          ref="infscroll"
          scroll-target="#routinesDiv"
          :initial-index="1"
        >
          <div class="q-pa-md">
            <q-input
              filled
              bottom-slots
              v-model="searchRoutines"
              label="Search"
              :dense="true"
              @keydown.enter="getRoutines"
            >
              <template v-slot:append>
                <q-icon
                  v-if="searchRoutines !== ''"
                  name="close"
                  @click="searchRoutines = ''"
                  class="cursor-pointer"
                />
                <q-icon
                  name="search"
                  class="cursor-pointer"
                  @click="getRoutines"
                />
              </template>
            </q-input>
          </div>
          <div>
            <q-list>
              <q-item>
                <q-item-section>
                  <q-item-label overline
                    >{{ routineTotal }} Routines</q-item-label
                  >
                  <q-item-label
                    >in {{ routinesPaths.length }} location(s)</q-item-label
                  >
                </q-item-section>
              </q-item>
              <div
                v-for="(rtn, index) in shownRoutineList"
                :key="'rlist-' + index"
              >
                <q-item clickable @click="populateRoutine(rtn)" :active="getCurrentActiveRoutine(rtn.r)">
                  <q-item-section>
                    <q-item-label>{{ rtn.r }}</q-item-label>
                  </q-item-section>
                  <q-item-section side>
                    <q-item-label caption>{{ rtn.p }}</q-item-label>
                  </q-item-section>
                </q-item>
                <q-separator inset />
              </div>
              <q-item
                clickable
                @click="loadMoreScrolledRoutines"
                v-if="!finishedLoadingAllRoutines"
              >
                <q-item-section>
                  <q-item-label style="margin:0 auto">load more</q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </div>
          <template v-slot:loading>
            <div class="row justify-center q-my-md">
              <q-spinner-dots color="primary" size="40px" />
            </div>
          </template>
        </q-infinite-scroll>
      </template>

      <template v-slot:after>
      <span class="text-center text-primary" style="font-size:22px;padding:10px">
        {{(currentActivePath + currentActiveRoutine) ? currentActivePath + currentActiveRoutine + '.m':'' }}
      </span>
        <codemirror
          v-if="code.length > 0"
          ref="cmEditor"
          :value="code"
          :options="cmOptions"
          @ready="onCmReady"
          @focus="onCmFocus"
          @input="onCmCodeChange"
        />
      </template>
    </q-splitter>
    <q-dialog v-model="loadingDialog" persistent>
      <q-card style="height:185px;width:300px">
        <q-card-section class="q-pa-md">
          <span style="font-size:18px;" class="flex flex-center"
            >Loading Routines. Please wait!</span
          >
        </q-card-section>
        <q-card-section class="q-pa-md">
          <div class="flex flex-center">
            <q-spinner-hourglass
              :color="$q.dark.isActive ? 'purple' : 'orange'"
              size="6em"
              v-if="loading"
              :thickness="0"
            />
          </div>
        </q-card-section>
      </q-card>
    </q-dialog>
  </div>
</template>
<script>
import { codemirror } from "vue-codemirror";
import "codemirror/mode/mumps/mumps.js";

export default {
  name: "Routines",
  components: {
    codemirror
  },
  data() {
    return {
      splitterModel: 35,
      searchRoutines: "YDB*",
      shownRoutineList: [],
      shownRoutineIndex: 0,
      routinePatchCount: 100,
      finishedLoadingAllRoutines: false,
      currentActiveRoutine:'',
      currentActivePath:'',
      code: "",
      cmOptions: {
        readOnly:true,
        tabSize: 4,
        mode: {
          name: "mumps"
        },
        theme: this.$q.dark.isActive ? "abcdef" : "default",
        lineNumbers: true,
        line: true
      },
      routinesList: [],
      routinesPaths: [],
      loading: false,
      loadingDialog: false,
      routineTotal: 0
    };
  },
  methods: {
    getCurrentActiveRoutine(rtn){
        return this.currentActiveRoutine === rtn
    },
    loadMoreRoutines(index, done) {
      this.shownRoutineIndex = index;
      for (
        let i = this.shownRoutineIndex * this.routinePatchCount;
        i <
        this.shownRoutineIndex * this.routinePatchCount +
          this.routinePatchCount;
        i++
      ) {
        if (this.routinesList[i]) {
          this.shownRoutineList.push(this.routinesList[i]);
        } else {
          this.finishedLoadingAllRoutines = true;
          done(true);
          return;
        }
      }
      done();
      this.$refs.infscroll.stop();
    },
    async populateRoutine(rtn){
      let data = await this.$M('POPULATEROUTINE^YDBWEBRTNS',{
        RTN: rtn.r,
        PATH: rtn.p
      })
        if (data.STATUS){
          this.code = data.CODE.join('\n')
          this.currentActiveRoutine  = rtn.r
          this.currentActivePath = rtn.p
        } else {
          this.$q.notify({
            message:'Routine could not be found!',
            color:'negative'
          })
        }
    },
    async getRoutines() {
      if (!this.searchRoutines.length) {
        return;
      }
      this.loadingDialog = true;
      this.shownRoutineList = [];
      this.shownRoutineIndex = 0;
      this.finishedLoadingAllRoutines = false;
      this.loading = true;
      let data = await this.$M("GETROUTINESLIST^YDBWEBRTNS", {
        PATTERN: this.searchRoutines
      });
      if (data && data.RTOTAL) {
        this.routineTotal = data.RTOTAL;
      } else {
        this.routineTotal = 0;
      }
      if (data && data.RLIST) {
        this.routinesList = data.RLIST;
      } else {
        this.routinesList = [];
      }
      if (data && data.PLIST) {
        this.routinesPaths = data.PLIST;
      } else {
        this.routinesPaths = [];
      }
      for (
        let i = this.shownRoutineIndex * this.routinePatchCount;
        i <
        this.shownRoutineIndex * this.routinePatchCount +
          this.routinePatchCount;
        i++
      ) {
        if (this.routinesList[i]) {
          this.shownRoutineList.push(this.routinesList[i]);
        } else {
          this.finishedLoadingAllRoutines = true;
        }
      }
      this.loading = false;
      this.loadingDialog = false;
    },
    onCmReady(cm) {
      // console.log("the editor is readied!", cm);
    },
    onCmFocus(cm) {
      // console.log("the editor is focused!", cm);
    },
    onCmCodeChange(newCode) {
      // console.log("this is new code", newCode);
      this.code = newCode;
    },
    loadMoreScrolledRoutines() {
      this.$refs.infscroll.resume();
      this.$refs.infscroll.trigger();
    }
  },
  computed: {
    codemirror() {
      // console.log("the current CodeMirror instance object:", this.codemirror);
      return this.$refs.cmEditor.codemirror;
    },
    theme() {
      return this.$q.dark.isActive;
    }
  },
  watch: {
    splitterModel(v) {
      this.$q.localStorage.set("ydb-routines-splitter", v);
    },
    theme(v) {
      if (v) {
        this.$set(this.cmOptions, "theme", "abcdef");
      } else {
        this.$set(this.cmOptions, "theme", "default");
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
    await this.getRoutines();
  }
};
</script>
<style>
@import "../../../node_modules/codemirror/lib/codemirror.css";
@import "../../../node_modules/codemirror/theme/abcdef.css";
.CodeMirror {
  border: 1px solid #eee;
  height: 84vh;
}
</style>
