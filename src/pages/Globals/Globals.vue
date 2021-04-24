<template>
  <div class="q-pa-md" id="globalsDiv">
    <div style="padding:5px">
     <q-breadcrumbs gutter="xs">
      <q-breadcrumbs-el label="Home" />
      <q-breadcrumbs-el label="System Explorer" />
      <q-breadcrumbs-el label="Globals" />
      </q-breadcrumbs>
    </div>
    <q-splitter
      v-model="splitterModel"
      style="height:89vh"
      v-if="!loading && !loadingDialog"
    >
      <template v-slot:before>
         <span class="text-center" style="font-size:28px;padding:25px">
        Gloabsl
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
                    >{{ globalTotal }} Globals</q-item-label
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
                <q-item clickable @click="populateGlobal(glbl)" :active="getCurrentActiveGlobal(glbl.g)">
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
        <h1>HI</h1>
      </template>
    </q-splitter>
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
  </div>
</template>
<script>

export default {
  name: "Globals",
  data() {
    return {
      splitterModel: 15,
      searchGlobals: "*",
      shownGlobalList: [],
      shownGlobalIndex: 0,
      globalPatchCount: 100,
      finishedLoadingAllGlobals: false,
      currentActiveGlobal:'',
      currentActivePath:'',
      globalsList: [],
      globalsPaths: [],
      loading: false,
      loadingDialog: false,
      globalTotal: 0
    };
  },
  methods: {
    getCurrentActiveGlobal(glbl){
        return this.currentActiveGlobal === glbl
    },
    loadMoreGlobals(index, done) {
      this.shownGlobalIndex = index;
      for (
        let i = this.shownGlobalIndex * this.globalPatchCount;
        i <
        this.shownGlobalIndex * this.globalPatchCount +
          this.globalPatchCount;
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
    async populateGlobal(glbl){
      let data = await this.$M('POPULATEGLOBALS^YDBWEBGLBLS',{
        GLBL: glbl.g
      })
        if (data.STATUS){
          this.currentActiveGlobal  = glbl.g
        } else {
          this.$q.notify({
            message:'Global could not be found!',
            color:'negative'
          })
        }
    },
    async getGlobals() {
      if (!this.searchGlobals.length) {
        return;
      }
      this.loadingDialog = true;
      this.shownGlobalList = [];
      this.shownGlobalIndex = 0;
      this.finishedLoadingAllGlobals = false;
      this.loading = true;
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
        this.shownGlobalIndex * this.globalPatchCount +
          this.globalPatchCount;
        i++
      ) {
        if (this.globalsList[i]) {
          this.shownGlobalList.push(this.globalsList[i]);
        } else {
          this.finishedLoadingAllGlobals = true;
        }
      }
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
    if (this.shownGlobalList[0]){
      this.populateGlobal(this.shownGlobalList[0])
    }
  }
};
</script>
<style>
</style>
