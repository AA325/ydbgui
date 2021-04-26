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
        <q-page-sticky v-show="loadedNodesMessage.indexOf('out of')>0" position="top" :offset="[18, 18]">
          <q-banner  dense class="text-white bg-red" v-show="showLoadedNodesBanner">
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
                  clickable
                  @click="filteredGlbl='';populateGlobal(glbl);"
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
                    @click="filteredGlbl = '';populateGlobal(selectedGlbl)"
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
              default-expand-all
              node-key="label"
              :selected.sync="selectedGlblNode"
              @lazy-load="onLazyLoadGlobalNodes"
            />
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
        @hide="selectedGlblNode=''"
        bordered
        :width="600"
        overlay
        content-class=""
      >  
        <q-bar>
          <q-icon name="laptop_chromebook" />
          <div>Google Chrome</div>
          <q-space />
          <q-btn dense flat icon="minimize" />
          <q-btn dense flat icon="crop_square" />
          <q-btn dense flat icon="close" />
        </q-bar>
      </q-drawer>
      
  </div>
</template>
<script>
export default {
  name: "Globals",
  data() {
    return {
      globalRightDrawer:false,
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
      nodesPagingSize: 100
    };
  },
  methods: {
    async onLazyLoadGlobalNodes(node) {
    // this.selectedGlbl = glbl;
      this.loadedNodesMessage = "";
      let done = false;
      setTimeout(() => {
        if (done) {
          return;
        }
        this.loadingNodes = true;
      }, 1000);
      let data = await this.$M("POPULATEGLOBALS^YDBWEBGLBLS", {
        GLBL: node.key,
        SEARCH: this.filteredGlbl,
        SIZE:this.nodesPagingSize
      });
      done = true;
      this.loadingNodes = false;
      if (data.STATUS) {
        // this.currentActiveGlobal = glbl.g;
        node.done(data.NODES)
        if (data.MESSAGE && data.MESSAGE.indexOf('out of')>0) {
          this.loadedNodesMessage = data.MESSAGE;
          this.showLoadedNodesBanner = true;
          setTimeout(() => {
            this.showLoadedNodesBanner = false;
          }, 5000);
        } else if (data.MESSAGE && data.MESSAGE){
            this.loadedNodesMessage = data.MESSAGE;
        }
      } else {
         node.done([])
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
      let data = await this.$M("POPULATEGLOBALS^YDBWEBGLBLS", {
        GLBL: glbl.g,
        SEARCH: this.filteredGlbl,
        SIZE:this.nodesPagingSize
      });
      done = true;
      this.loadingNodes = false;
      if (data.STATUS) {
        this.currentActiveGlobal = glbl.g;
        this.globalNodes = data.NODES;

        if (data.MESSAGE && data.MESSAGE.indexOf('out of')>0) {
          this.loadedNodesMessage = data.MESSAGE;
          this.showLoadedNodesBanner = true;
          setTimeout(() => {
            this.showLoadedNodesBanner = false;
          }, 5000);
        } else if (data.MESSAGE && data.MESSAGE){
            this.loadedNodesMessage = data.MESSAGE;
        }
      } else {
        this.globalNodes = []
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
      let data = await this.$M("GETGLOBALSLIST^YDBWEBGLBLS", {
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
    }
  },
  computed: {
    theme() {
      return this.$q.dark.isActive;
    }
  },
  watch: {
      selectedGlblNode(v){
      if (v){
        this.globalRightDrawer = true
      } else {
        this.globalRightDrawer = false
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
<style></style>
