<template>
  <div class="q-pa-md" id="globalsDiv">
    <div style="padding:5px">
      <q-breadcrumbs gutter="xs">
        <q-breadcrumbs-el label="Home" />
        <q-breadcrumbs-el label="System Explorer" />
        <q-breadcrumbs-el label="Globals" />
        <q-breadcrumbs-el
          v-if="!showLoadedNodesBanner && loadedNodesMessage"
          :label="loadedNodesMessage"
        />
      </q-breadcrumbs>
      <transition
        appear
        enter-active-class="animated fadeIn"
        leave-active-class="animated fadeOut"
      >
        <q-page-sticky
          v-show="loadedNodesMessage.indexOf('out of') > 0"
          position="top"
          :offset="[18, 18]"
        >
          <q-banner
            dense
            class="text-white bg-red"
            v-show="showLoadedNodesBanner"
          >
            {{ loadedNodesMessage }}
          </q-banner>
        </q-page-sticky>
      </transition>
    </div>
    <transition
      enter-active-class="animated fadeIn"
      leave-active-class="animated fadeOut"
    >
      <q-splitter
        v-model="splitterModel"
        style="height:calc(100vh - 125px)"
        v-if="!loading && !loadingDialog"
      >
        <template v-slot:before>
          <span class="text-center" style="font-size:28px;padding:5px">
            Globals
          </span>
          <q-infinite-scroll
            @load="loadMoreGlobals"
            :offset="0"
            ref="infscroll"
            scroll-target="#globalsDiv"
            :initial-index="1"
          >
            <div class="q-pa-md">
              <q-input
                filled
                bottom-slots
                v-model="searchGlobals"
                label="Search"
                :dense="true"
                @keydown.enter="getGlobals"
              >
                <template v-slot:append>
                  <q-icon
                    v-if="searchGlobals !== ''"
                    name="close"
                    @click="searchGlobals = ''"
                    class="cursor-pointer"
                  />
                  <q-icon
                    name="search"
                    class="cursor-pointer"
                    @click="getGlobals"
                  />
                </template>
              </q-input>
            </div>
            <div>
              <q-list>
                <q-item>
                  <q-item-section>
                    <q-item-label overline
                      >{{ globalTotal }} Global(s)</q-item-label
                    >
                    <!--
                  <q-item-label
                    >in {{ globalsPaths.length }} location(s)</q-item-label
                  >-->
                  </q-item-section>
                </q-item>
                <div
                  v-for="(glbl, index) in shownGlobalList"
                  :key="'glist-' + index"
                >
                  <q-item
                    dense
                    clickable
                    @click="
                      filteredGlbl = '';
                      populateGlobal(glbl);
                    "
                    :active="getCurrentActiveGlobal(glbl.g)"
                  >
                    <q-item-section>
                      <q-item-label>{{ glbl.g }}</q-item-label>
                    </q-item-section>
                    <!--
                  <q-item-section side>
                    <q-item-label caption>{{ glbl.p }}</q-item-label>
                  </q-item-section>
                -->
                  </q-item>
                  <q-separator inset />
                </div>
                <q-item
                  clickable
                  @click="loadMoreScrolledGlobals"
                  v-if="!finishedLoadingAllGlobals"
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
          <div class="q-pa-md q-col-gutter-sm">
            <div
              v-if="loadingNodes"
              class="flex items-center justify-center"
              style="height:calc(100vh - 125px);"
            >
              <q-spinner-hourglass
                :color="$q.dark.isActive ? 'purple' : 'orange'"
                size="10em"
              />
            </div>
            <div class="row">
              <div class="col-8" style="padding:5px" v-show="!loadingNodes">
                <q-input
                  filled
                  bottom-slots
                  v-model="filteredGlbl"
                  label="Globals Search"
                  :dense="true"
                  @keydown.enter="populateGlobal(selectedGlbl)"
                >
                  <template v-slot:append>
                    <q-icon
                      v-if="filteredGlbl !== ''"
                      name="close"
                      @click="
                        filteredGlbl = '';
                        populateGlobal(selectedGlbl);
                      "
                      class="cursor-pointer"
                    />
                    <q-icon
                      name="search"
                      class="cursor-pointer"
                      @click="populateGlobal(selectedGlbl)"
                    />
                  </template>
                </q-input>
              </div>
              <div class="col-4" style="padding:5px" v-show="!loadingNodes">
                <q-select
                  @input="populateGlobal(selectedGlbl)"
                  dense
                  filled
                  v-model="nodesPagingSize"
                  :options="[100, 1000, 10000]"
                  label="Number of nodes to show"
                />
              </div>
            </div>
            <div class="row" v-show="!loadingNodes">
              <q-tree
                :nodes="globalNodes"
                node-key="key"
                :selected.sync="selectedGlblNode"
                @lazy-load="onLazyLoadGlobalNodes"
                icon="arrow_forward_ios"
              >
                <template v-slot:default-body="prop">
                  <span class="text-primary">
                    {{ prop.node.story }}
                  </span>
                </template>
              </q-tree>
            </div>
          </div>
        </template>
      </q-splitter>
    </transition>
    <q-dialog v-model="loadingDialog" persistent>
      <q-card style="height:185px;width:300px">
        <q-card-section class="q-pa-md">
          <span style="font-size:18px;" class="flex flex-center"
            >Loading Globals. Please wait!</span
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
    <q-drawer
      side="right"
      v-model="globalRightDrawer"
      @hide="
        code = '';
        codeIcon = '';
        globalRightDrawer = false;
        selectedGlblNode = '';
      "
      bordered
      :width="600"
      overlay
      content-class="width:600px"
    >
      <q-card style="height:100%">
        <q-bar
          :class="
            !$q.dark.isActive ? 'bg-purple text-white' : 'bg-orange text-white'
          "
          color="white"
        >
          Global Node Value
          <q-space />
          <q-btn
            dense
            flat
            icon="close"
            color="white"
            @click="
              code = '';
              codeIcon = '';
              globalRightDrawer = false;
              selectedGlblNode = '';
            "
          />
        </q-bar>
        <q-card-section>
          <q-icon :name="codeIcon" style="font-size: 5rem;" />
          <span class="wraptext">{{ selectedGlblNode }}</span>
        </q-card-section>
        <q-card-section>
          <codemirror
            id="codeMirrorGlobals"
            ref="cmEditor"
            @input="onCmCodeChange"
            :value="code"
            :options="cmOptions"
          />
        </q-card-section>
        <q-card-section>
          <pre>
            Character Count: {{ code.length }}
          </pre>
          <div class="q-gutter-sm">
            <q-radio v-model="codeLineBreak" :val="true" label="Wrap Line(s)" />
            <q-radio
              v-model="codeLineBreak"
              :val="false"
              label="Don't Wrap Line(s)"
            />
          </div>
        </q-card-section>
        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="SAVE (SET)" @click="saveGlobal" />
          <q-btn
            flat
            color="negative"
            label="KILL GLOBAL (KILL)"
            @click="killGlobal"
          />
          <q-btn
            v-if="codeIcon !== 'text_snippet'"
            flat
            color="purple"
            label="REMOVE VALUE (ZKILL)"
            @click="zkillGlobal"
          />
          <q-btn
            flat
            color="orange"
            label="CANCEL"
            @click="
              code = '';
              codeIcon = '';
              globalRightDrawer = false;
              selectedGlblNode = '';
            "
          />
        </q-card-actions>
      </q-card>
    </q-drawer>
  </div>
</template>
<script>
import { codemirror } from "vue-codemirror";
export default {
  name: "Globals",
  components: {
    codemirror
  },
  data() {
    return {
      codeIcon: "",
      updatedNodeValue:"",
      globalRightDrawer: false,
      selectedGlblNode: "",
      globalNodes: [],
      splitterModel: 15,
      searchGlobals: "*",
      shownGlobalList: [],
      shownGlobalIndex: 0,
      globalPatchCount: 100,
      finishedLoadingAllGlobals: false,
      currentActiveGlobal: "",
      currentActivePath: "",
      globalsList: [],
      globalsPaths: [],
      loading: false,
      loadingDialog: false,
      globalTotal: 0,
      loadingNodes: false,
      loadedNodesMessage: "",
      showLoadedNodesBanner: false,
      selectedGlbl: "",
      filteredGlbl: "",
      nodesPagingSize: 100,
      codeLineBreak: false,
      code: "",
      cmOptions: {
        tabSize: 4,
        lineWrapping: false,
        mode: {
          name: "text"
        },
        theme: this.$q.dark.isActive ? "abcdef" : "default",
        lineNumbers: true,
        line: true
      }
    };
  },
  methods: {
    async onLazyLoadGlobalNodes(node) {
      console.log(node);
      // this.selectedGlbl = glbl;
      this.loadedNodesMessage = "";
      let done = false;
      setTimeout(() => {
        if (done) {
          return;
        }
        this.loadingNodes = true;
      }, 1000);
      let data = await this.$M("POPULATEGLOBALS^%YDBWEBGLBLS", {
        GLBL: node.key,
        SEARCH: this.filteredGlbl,
        SIZE: this.nodesPagingSize
      });
      done = true;
      this.loadingNodes = false;
      if (data.STATUS) {
        // this.currentActiveGlobal = glbl.g;
        node.done(data.NODES);
        if (data.MESSAGE && data.MESSAGE.indexOf("out of") > 0) {
          this.loadedNodesMessage = data.MESSAGE;
          this.showLoadedNodesBanner = true;
          setTimeout(() => {
            this.showLoadedNodesBanner = false;
          }, 5000);
        } else if (data.MESSAGE) {
          this.loadedNodesMessage = data.MESSAGE;
        }
      } else {
        node.done([]);
        this.$q.notify({
          message: "Globals could not be found!",
          color: "negative"
        });
      }
    },
    getCurrentActiveGlobal(glbl) {
      return this.currentActiveGlobal === glbl;
    },
    loadMoreGlobals(index, done) {
      this.shownGlobalIndex = index;
      for (
        let i = this.shownGlobalIndex * this.globalPatchCount;
        i <
        this.shownGlobalIndex * this.globalPatchCount + this.globalPatchCount;
        i++
      ) {
        if (this.globalsList[i]) {
          this.shownGlobalList.push(this.globalsList[i]);
        } else {
          this.finishedLoadingAllGlobals = true;
          done(true);
          return;
        }
      }
      done();
      this.$refs.infscroll.stop();
    },
    async populateGlobal(glbl) {
      this.selectedGlbl = glbl;
      this.loadedNodesMessage = "";
      let done = false;
      setTimeout(() => {
        if (done) {
          return;
        }
        this.loadingNodes = true;
      }, 1000);
      let data = await this.$M("POPULATEGLOBALS^%YDBWEBGLBLS", {
        GLBL: glbl.g,
        SEARCH: this.filteredGlbl,
        SIZE: this.nodesPagingSize
      });
      done = true;
      this.loadingNodes = false;
      if (data.STATUS) {
        this.currentActiveGlobal = glbl.g;
        this.globalNodes = data.NODES;

        if (data.MESSAGE && data.MESSAGE.indexOf("out of") > 0) {
          this.loadedNodesMessage = data.MESSAGE;
          this.showLoadedNodesBanner = true;
          setTimeout(() => {
            this.showLoadedNodesBanner = false;
          }, 5000);
        } else if (data.MESSAGE && data.MESSAGE) {
          this.loadedNodesMessage = data.MESSAGE;
        }
      } else {
        this.globalNodes = [];
        this.$q.notify({
          message: "Globals could not be found!",
          color: "negative"
        });
      }
    },
    async getGlobals() {
      if (!this.searchGlobals.length) {
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
      this.shownGlobalList = [];
      this.shownGlobalIndex = 0;
      this.finishedLoadingAllGlobals = false;
      let data = await this.$M("GETGLOBALSLIST^%YDBWEBGLBLS", {
        PATTERN: this.searchGlobals
      });
      if (data && data.GTOTAL) {
        this.globalTotal = data.GTOTAL;
      } else {
        this.globalTotal = 0;
      }
      if (data && data.GLIST) {
        this.globalsList = data.GLIST;
      } else {
        this.globalsList = [];
      }
      for (
        let i = this.shownGlobalIndex * this.globalPatchCount;
        i <
        this.shownGlobalIndex * this.globalPatchCount + this.globalPatchCount;
        i++
      ) {
        if (this.globalsList[i]) {
          this.shownGlobalList.push(this.globalsList[i]);
        } else {
          this.finishedLoadingAllGlobals = true;
        }
      }
      done = true;
      this.loading = false;
      this.loadingDialog = false;
    },
    loadMoreScrolledGlobals() {
      this.$refs.infscroll.resume();
      this.$refs.infscroll.trigger();
    },
    async getSelectedGlobalValue(global) {
      let code = "";
      let icon = "";
      let data = await this.$M("GETGLOBALVALUE^%YDBWEBGLBLS", {
        GLOBAL: global
      });
      if (data && data.STATUS) {
        code = String(data.VALUE);
        icon = data.ICON;
      } else {
        code = "";
        icon = "";
        this.$q.notify({
          message: "Global couldn't be found!",
          color: "negative"
        });
      }
      return { code, icon };
    },
    onCmCodeChange(newCode) {
      this.code = newCode;
    },
    async saveGlobal() {
      this.$q
        .dialog({
          title: "Confirm",
          message: "Are you sure you want to save global?",
          cancel: true,
          persistent: true
        })
        .onOk(async () => {
          let data = await this.$M("SAVEGLOBAL^%YDBWEBGLBLS", {
            GLOBAL: this.selectedGlblNode,
            VALUE: this.code
          });
          if (data && data.STATUS) {
            this.$q.notify({
              message: "Global saved!",
              color: "positive"
            });
            this.updateIcon(data.ICON);
            this.updateValue(this.code)
            this.globalRightDrawer = false;
            this.code = "";
            this.codeIcon = "";
            this.selectedGlblNode = "";
          } else {
            this.$q.notify({
              message: "Error ocurred. Global not saved!",
              color: "negative"
            });
          }
        });
    },
    async zkillGlobal() {
      this.$q
        .dialog({
          title: "Confirm",
          message:
            "Are you sure you want to Zkill the global (remove its value) ?",
          cancel: true,
          persistent: true
        })
        .onOk(async () => {
          let data = await this.$M("ZKILLLOBAL^%YDBWEBGLBLS", {
            GLOBAL: this.selectedGlblNode
          });
          if (data && data.STATUS) {
            this.$q.notify({
              message: "Global ZKILLED!",
              color: "positive"
            });
            this.updateIcon(data.ICON);
            this.updateValue('')
            this.globalRightDrawer = false;
            this.code = "";
            this.codeIcon = "";
            this.selectedGlblNode = "";
          } else {
            this.$q.notify({
              message: "Error ocurred. Global not ZKILLED!",
              color: "negative"
            });
          }
        });
    },
    async killGlobal() {
      this.$q
        .dialog({
          title: "Confirm",
          message: "Are you sure you want to kill the global?",
          cancel: true,
          persistent: true
        })
        .onOk(async () => {
          let data = await this.$M("KILLGLOBAL^%YDBWEBGLBLS", {
            GLOBAL: this.selectedGlblNode
          });
          if (data && data.STATUS) {
            this.$q.notify({
              message: "Global killed!",
              color: "positive"
            });
            this.globalRightDrawer = false;
            this.code = "";
            this.codeIcon = "";
            this.selectedGlblNode = "";
            this.globalNodes = "";
            this.shownGlobalList = [];
            this.shownGlobalIndex = 0;
            this.currentActiveGlobal = "";
            this.globalsList = [];
            this.globalTotal = 0;
            this.selectedGlbl = "";
            this.filteredGlbl = "";
            await this.getGlobals();
            if (this.shownGlobalList[0]) {
              this.populateGlobal(this.shownGlobalList[0]);
            }
          } else {
            this.$q.notify({
              message: "Error ocurred. Global not killed!",
              color: "negative"
            });
          }
        });
    },
    updateIcon(icon) {
      let self = this;
      let nodes = this.globalNodes;
      function parseObjectProperties(obj) {
        for (var k in obj) {
          if (typeof obj[k] === "object" && obj[k] !== null) {
            parseObjectProperties(obj[k]);
          } else if (obj.hasOwnProperty(k)) {
            if (k === "key" && obj[k] === self.selectedGlblNode) {
              obj["icon"] = icon;
            }
          }
        }
      }
      parseObjectProperties(nodes);
      this.globalNodes = nodes;
    },
    updateValue(value){
      let self = this;
      let nodes = this.globalNodes;
      function parseObjectProperties(obj) {
        for (var k in obj) {
          if (typeof obj[k] === "object" && obj[k] !== null) {
            parseObjectProperties(obj[k]);
          } else if (obj.hasOwnProperty(k)) {
            if (k === "key" && obj[k] === self.selectedGlblNode) {
              obj["story"] = value;
            }
          }
        }
      }
      parseObjectProperties(nodes);
      this.globalNodes = nodes;
    }
  },
  computed: {
    theme() {
      return this.$q.dark.isActive;
    },
    codemirror() {
      return this.$refs.cmEditor.codemirror;
    }
  },
  watch: {
    codeLineBreak(v) {
      if (v) {
        this.$set(this.cmOptions, "lineWrapping", true);
      } else {
        this.$set(this.cmOptions, "lineWrapping", false);
      }
    },
    theme(v) {
      if (v) {
        this.$set(this.cmOptions, "theme", "abcdef");
      } else {
        this.$set(this.cmOptions, "theme", "default");
      }
    },
    async selectedGlblNode(v) {
      if (v) {
        let data = await this.getSelectedGlobalValue(v);
        this.code = String(data.code);
        this.codeIcon = data.icon;
        this.globalRightDrawer = true;
      } else {
        this.globalRightDrawer = false;
        this.code = "";
        this.codeIcon = "";
      }
    },
    splitterModel(v) {
      this.$q.localStorage.set("ydb-globals-splitter", v);
    }
  },
  created() {
    let splitterModel = this.$q.localStorage.getItem("ydb-globals-splitter");
    if (splitterModel) {
      this.splitterModel = splitterModel;
    }
  },
  async mounted() {
    await this.getGlobals();
    if (this.shownGlobalList[0]) {
      this.populateGlobal(this.shownGlobalList[0]);
    }
  }
};
</script>
<style>
@import "../../../node_modules/codemirror/lib/codemirror.css";
@import "../../../node_modules/codemirror/theme/abcdef.css";
#codeMirrorGlobals > .CodeMirror {
  border: 1px solid #eee;
  height: calc(100vh - 600px);
}
.wraptext,
pre {
  white-space: pre-wrap; /* Since CSS 2.1 */
  white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
  white-space: -pre-wrap; /* Opera 4-6 */
  white-space: -o-pre-wrap; /* Opera 7 */
  word-wrap: break-word; /* Internet Explorer 5.5+ */
}
</style>
