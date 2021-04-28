<template>
  <div class="q-pa-md" id="routinesDiv">
    <q-page-sticky position="top-right" :offset="[20, 3]">
      <q-btn
        fab
        icon="delete"
        @click="deleteRoutine"
        padding="sm"
        :color="'negative'"
        style="margin-right:15px"
      />
      <q-btn
        fab
        icon="save"
        @click="saveRoutine"
        padding="sm"
        :color="$q.dark.isActive ? 'purple' : 'orange'"
        style="margin-right:15px"
      />
      <q-btn
        fab
        icon="add"
        @click="createRoutine"
        padding="sm"
        :color="'primary'"
      />
      <!-- <q-btn fab icon="delete" padding="xs" :color="'red'" /> -->
    </q-page-sticky>
    <div style="padding:5px">
      <q-breadcrumbs gutter="xs">
        <q-breadcrumbs-el label="Home" />
        <q-breadcrumbs-el label="System Explorer" />
        <q-breadcrumbs-el label="Routines" />
        <q-breadcrumbs-el
          :label="
            currentActivePath + currentActiveRoutine
              ? currentActivePath + currentActiveRoutine + '.m'
              : ''
          "
        />
      </q-breadcrumbs>
    </div>
    <q-splitter
      v-model="splitterModel"
      style="height:calc(100vh - 121px)"
      v-if="!loading && !loadingDialog"
    >
      <template v-slot:before>
        <span class="text-center" style="font-size:28px;padding:25px">
          Routines
        </span>
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
                  <!--
                  <q-item-label
                    >in {{ routinesPaths.length }} location(s)</q-item-label
                  >-->
                </q-item-section>
              </q-item>
              <div
                v-for="(rtn, index) in shownRoutineList"
                :key="'rlist-' + index"
              >
                <q-item
                  clickable
                  @click="populateRoutine(rtn)"
                  :active="getCurrentActiveRoutine(rtn.r)"
                  dense
                >
                  <q-item-section>
                    <q-item-label>{{ rtn.r }}</q-item-label>
                  </q-item-section>
                  <!--
                  <q-item-section side>
                    <q-item-label caption>{{ rtn.p }}</q-item-label>
                  </q-item-section>
                -->
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
        <codemirror
          id="codeMirrorRoutines"
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
    <q-dialog v-model="createRoutineDialog" persistent>
      <q-card style="width:300px">
        <q-card-section class="q-pa-md">
          <span style="font-size:18px;" class="flex flex-center"
            >Create New Routine</span
          >
        </q-card-section>
        <q-card-section>
          <q-input
            outlined
            v-model="newRoutineName"
            label="Routine Name*"
            dense
            ref="newRoutineField"
            lazy-rules
            :rules="[val => checkRoutineName(val) || 'Invalid routine name']"
          />
          <q-select
            lazy-rules
            ref="pathField"
            :rules="[val => val.length > 0 || 'Routine location is required!']"
            dense
            filled
            v-model="newRoutinePath"
            :value="newRoutinePath[0]"
            :options="newRoutinePaths"
            label="Routine Location*"
          />
        </q-card-section>
        <q-card-actions align="right" class="text-primary">
          <q-btn
            flat
            label="Cancel"
            color="warning"
            @click="cancelCreateNewRoutine"
          />
          <q-btn flat label="OK" @click="createNewRoutine" />
        </q-card-actions>
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
      newRoutinePath: "",
      newRoutinePaths: [],
      newRoutineName: "",
      createRoutineDialog: false,
      splitterModel: 10,
      searchRoutines: "%YDB*",
      shownRoutineList: [],
      shownRoutineIndex: 0,
      routinePatchCount: 100,
      finishedLoadingAllRoutines: false,
      currentActiveRoutine: "",
      currentActivePath: "",
      code: "",
      cmOptions: {
        tabSize: 4,
        mode: {
          name: "mumps"
        },
        theme: this.$q.dark.isActive ? "abcdef" : "default",
        lineNumbers: true,
        line: true,
        extraKeys: {
          "Ctrl-S": async instance => {
            await this.saveRoutine();
          }
        }
      },
      routinesList: [],
      routinesPaths: [],
      loading: false,
      loadingDialog: false,
      routineTotal: 0
    };
  },
  methods: {
    checkRoutineName(value) {
      let valid = true;
      if (!value) {
        return false;
      }
      let dict = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split(
        ""
      );
      let digits = "0123456789".split("");
      let fulldict = dict.concat(digits);
      let valueArr = value.split("");
      for (let i = 0; i < valueArr.length; i++) {
        if (i === 0 && !dict.includes(valueArr[i]) && valueArr[i] !== "%") {
          valid = false;
        } else if (i > 0 && !fulldict.includes(valueArr[i])) {
          valid = false;
        }
      }
      return valid;
    },
    getCurrentActiveRoutine(rtn) {
      return this.currentActiveRoutine === rtn;
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
    async populateRoutine(rtn) {
      let data = await this.$M("POPULATEROUTINE^%YDBWEBRTNS", {
        RTN: rtn.r,
        PATH: rtn.p
      });
      if (data.STATUS && data.CODE && data.CODE.length > 0) {
        this.code = data.CODE.join("\n");
        this.currentActiveRoutine = rtn.r;
        this.currentActivePath = rtn.p;
      } else {
        this.currentActiveRoutine = "";
        this.currentActivePath = "";
        this.$q.notify({
          message: "Routine could not be found!",
          color: "negative"
        });
      }
    },
    async getRoutines() {
      if (!this.searchRoutines.length) {
        return;
      }
      let done = false;
      setTimeout(() => {
        if (done) {
          return;
        }
        this.loading = true;
        this.loadingDialog = true;
      }, 1000);
      this.shownRoutineList = [];
      this.shownRoutineIndex = 0;
      this.finishedLoadingAllRoutines = false;
      let data = await this.$M("GETROUTINESLIST^%YDBWEBRTNS", {
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
      done = true;
      this.loading = false;
      this.loadingDialog = false;
    },
    onCmReady(cm) {},
    onCmFocus(cm) {},
    onCmCodeChange(newCode) {
      this.code = newCode;
    },
    loadMoreScrolledRoutines() {
      this.$refs.infscroll.resume();
      this.$refs.infscroll.trigger();
    },
    async saveRoutine() {
      let data = await this.$M("SAVEROUTINE^%YDBWEBRTNS", {
        ROUTINE: this.currentActiveRoutine,
        PATH: this.currentActivePath,
        DATA: this.code.split("\n")
      });
      if (data.STATUS) {
        this.$q.notify({
          message: "Routine saved!",
          color: "positive"
        });
      } else {
        this.$q.notify({
          message: "Routine could not be saved!",
          color: "negative"
        });
      }
    },
    async deleteRoutine() {
      this.$q
        .dialog({
          title: "Delete Routine",
          message:
            "Are you sure you want to delete " +
            this.currentActivePath +
            this.currentActiveRoutine,
          cancel: true,
          persistent: true
        })
        .onOk(async () => {
          let data = await this.$M("DELETEROUTINE^%YDBWEBRTNS", {
            ROUTINE: this.currentActiveRoutine,
            PATH: this.currentActivePath
          });
          if (data.STATUS) {
            this.$q.notify({
              message: "Routine deleted!",
              color: "positive"
            });
            await this.getRoutines();
            if (this.shownRoutineList[0]) {
              this.populateRoutine(this.shownRoutineList[0]);
            }
          } else {
            this.$q.notify({
              message: "Routine could not be deleted!",
              color: "negative"
            });
          }
        });
    },
    async createRoutine() {
      let data = await this.$M("GETROUTINEPATHS^%YDBWEBRTNS");
      if (data && data.STATUS) {
        this.newRoutinePaths = data.PATHS;
        this.createRoutineDialog = true;
        this.newRoutinePath = data.PATHS[0];
      } else {
        this.$q.notify({
          message: "Could not get routine paths!",
          color: "negative"
        });
      }
    },
    async createNewRoutine() {
      this.$refs.newRoutineField.validate();
      this.$refs.pathField.validate();

      if (
        this.$refs.newRoutineField.hasError ||
        this.$refs.pathField.hasError
      ) {
        this.$q.notify({
          message: "Please enter a valid routine name and location",
          color: "negative"
        });
        return;
      } else {
        let data = await this.$M("CREATENEWROUTINE^%YDBWEBRTNS", {
          ROUTINE: this.newRoutineName,
          PATH: this.newRoutinePath
        });
        if (data && data.STATUS) {
          this.$q.notify({
            color: "positive",
            message: "Routine: " + this.newRoutineName + " created successfully"
          });
          await this.getRoutines();
          if (this.shownRoutineList[0]) {
            this.populateRoutine(this.shownRoutineList[0]);
          }
          this.createRoutineDialog = false;
          this.newRoutineName = "";
        } else {
          this.$q.notify({
            message: "Routine could not be created. It might already exists",
            color: "negative"
          });
        }
      }
    },
    cancelCreateNewRoutine() {
      this.createRoutineDialog = false;
      this.newRoutineName = "";
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
    if (this.shownRoutineList[0]) {
      this.populateRoutine(this.shownRoutineList[0]);
    }
  }
};
</script>
<style>
@import "../../../node_modules/codemirror/lib/codemirror.css";
@import "../../../node_modules/codemirror/theme/abcdef.css";
#codeMirrorRoutines > .CodeMirror {
  border: 1px solid #eee;
  height: calc(100vh - 121px);
}
</style>
