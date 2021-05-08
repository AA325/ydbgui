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
  <div class="q-pa-md" id="tablesDiv">
    <div style="padding:5px">
      <q-breadcrumbs gutter="xs">
        <q-breadcrumbs-el label="Home" />
        <q-breadcrumbs-el label="System Explorer" />
        <q-breadcrumbs-el label="OCTO Tables" />
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
          <span
            :class="$q.dark.isActive ? 'text-orange' : 'text-purple'"
            style="font-size:28px;padding:5px"
          >
            OCTO Tables
          </span>
          <q-infinite-scroll
            @load="loadMoreTables"
            :offset="0"
            ref="infscroll"
            scroll-target="#tablesDiv"
            :initial-index="1"
          >
            <div class="q-pa-md">
              <q-input
                filled
                bottom-slots
                v-model="searchTables"
                label="Search"
                :dense="true"
                @keydown.enter="getTables"
              >
                <template v-slot:append>
                  <q-icon
                    v-if="searchTables !== ''"
                    name="close"
                    @click="searchTables = ''"
                    class="cursor-pointer"
                  />
                  <q-icon
                    name="search"
                    class="cursor-pointer"
                    @click="getTables"
                  />
                </template>
              </q-input>
            </div>
            <div>
              <q-list>
                <q-item>
                  <q-item-section>
                    <q-item-label
                      overline
                      :class="$q.dark.isActive ? 'text-orange' : 'text-purple'"
                      >{{ tableTotal }} Table(s)</q-item-label
                    >
                    <!--
                  <q-item-label
                    >in {{ tablesPaths.length }} location(s)</q-item-label
                  >-->
                  </q-item-section>
                </q-item>
                <div
                  v-for="(tbl, index) in shownTableList"
                  :key="'table-list-' + index"
                >
                  <q-item
                    dense
                    clickable
                    @click="
                      filteredTbl = '';
                      populateTable(tbl);
                    "
                    :active="getCurrentActiveTable(tbl.T)"
                  >
                    <q-item-section>
                      <q-item-label>{{ tbl.T }}</q-item-label>
                    </q-item-section>
                    <!--
                  <q-item-section side>
                    <q-item-label caption>{{ tbl.p }}</q-item-label>
                  </q-item-section>
                -->
                  </q-item>
                  <q-separator inset />
                </div>
                <q-item
                  clickable
                  @click="loadMoreScrolledTables"
                  v-if="!finishedLoadingAllTables"
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
          <div class="q-pa-md">
            <q-card>
              <q-card-section>
                <span
                  :class="
                    $q.dark.isActive
                      ? 'text-orange text-bold'
                      : 'text-purple text-bold'
                  "
                >
                  SQL Statement:
                </span>
                <codemirror
                  id="codeMirrorTables"
                  ref="cmEditor"
                  @input="onCmCodeChange"
                  :value="code"
                  :options="cmOptions"
                />
                <q-btn
                  :color="$q.dark.isActive ? 'orange' : 'purple'"
                  flat
                  label="EXECUTE"
                  @click="executeSqlStatement"
                />
                <div class="row justify-center q-my-md" v-if="loadingTable">
                  <q-spinner-dots
                    :color="$q.dark.isActive ? 'purple' : 'orange'"
                    size="6em"
                  />
                </div>
                <hot-table
                  v-if="hotSettings.data.length > 0 && !loadingTable"
                  :settings="hotSettings"
                  :id="
                    $q.dark.isActive ? 'sqlhottable-dark' : 'sqlhottable-light'
                  "
                ></hot-table>
              </q-card-section>
            </q-card>
          </div>
        </template>
      </q-splitter>
    </transition>
  </div>
</template>
<script>
import { codemirror } from "vue-codemirror";
import { HotTable } from "@handsontable/vue";
import "codemirror/mode/sql/sql.js";
export default {
  name: "OCTOSQL",
  components: {
    codemirror,
    HotTable
  },
  data() {
    return {
      hotSettings: {
        data: [],
        licenseKey: "non-commercial-and-evaluation",
        colHeaders: true,
        rowHeaders: true,
        width: "100%",
        height: "calc(100vh - 396px)",
        colHeaders:[]
      },
      codeIcon: "",
      updatedNodeValue: "",
      tableRightDrawer: false,
      selectedTblNode: "",
      tableNodes: [],
      splitterModel: 15,
      searchTables: "*",
      shownTableList: [],
      shownTableIndex: 0,
      tablePatchCount: 100,
      finishedLoadingAllTables: false,
      currentActiveTable: "",
      currentActivePath: "",
      tablesList: [],
      tablesPaths: [],
      loading: false,
      loadingDialog: false,
      tableTotal: 0,
      loadingTable: false,
      loadedNodesMessage: "",
      showLoadedNodesBanner: false,
      selectedTbl: "",
      filteredTbl: "",
      nodesPagingSize: 100,
      codeLineBreak: false,
      code: "",
      cmOptions: {
        tabSize: 4,
        lineWrapping: false,
        mode: {
          name: "sql"
        },
        theme: this.$q.dark.isActive ? "abcdef" : "default",
        lineNumbers: true,
        line: true
      }
    };
  },
  methods: {
    async executeSqlStatement() {
      let done = false;
      setTimeout(() => {
        if (done) {
          return;
        }
        this.loadingTable = true;
      }, 1000);
      this.$set(this.hotSettings,'data',[])
      this.$set(this.hotSettings,'colHeaders',[])
      let data = await this.$M("EXECUTESQL^%YDBWEBTBLS", {
        STATEMENT: this.code
      });
      done = true;
      this.loadingTable = false;
      if (data && data.RESULT){
        this.$set(this.hotSettings,'data',data.RESULT.splice(1))
        this.$set(this.hotSettings,'colHeaders',data.RESULT[0])
      } else {
        this.$set(this.hotSettings,'data',[])
        this.$set(this.hotSettings,'data',[])
      }
    },
    getCurrentActiveTable(tbl) {
      return this.currentActiveTable === tbl;
    },
    loadMoreTables(index, done) {
      this.shownTableIndex = index;
      for (
        let i = this.shownTableIndex * this.tablePatchCount;
        i < this.shownTableIndex * this.tablePatchCount + this.tablePatchCount;
        i++
      ) {
        if (this.tablesList[i]) {
          this.shownTableList.push(this.tablesList[i]);
        } else {
          this.finishedLoadingAllTables = true;
          done(true);
          return;
        }
      }
      done();
      this.$refs.infscroll.stop();
    },
    async populateTable(tbl) {
      this.selectedTblNode = "";
      this.selectedTbl = tbl;
      this.loadedNodesMessage = "";
      this.code = `SELECT * FROM ${tbl.T} LIMIT 100;`;
      this.currentActiveTable = tbl.T;
      this.$set(this.hotSettings,'data',[])
      this.$set(this.hotSettings,'data',[])
      await this.executeSqlStatement()
    },
    async getTables() {
      if (!this.searchTables.length) {
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
      this.shownTableList = [];
      this.shownTableIndex = 0;
      this.finishedLoadingAllTables = false;
      let data = await this.$M("GETTABLESLIST^%YDBWEBTBLS", {
        PATTERN: this.searchTables
      });
      if (data && data.TABLETOTAL) {
        this.tableTotal = data.TABLETOTAL;
      } else {
        this.tableTotal = 0;
      }
      if (data && data.TABLELIST) {
        this.tablesList = data.TABLELIST;
      } else {
        this.tablesList = [];
      }
      for (
        let i = this.shownTableIndex * this.tablePatchCount;
        i < this.shownTableIndex * this.tablePatchCount + this.tablePatchCount;
        i++
      ) {
        if (this.tablesList[i]) {
          this.shownTableList.push(this.tablesList[i]);
        } else {
          this.finishedLoadingAllTables = true;
        }
      }
      done = true;
      this.loading = false;
      this.loadingDialog = false;
    },
    loadMoreScrolledTables() {
      this.$refs.infscroll.resume();
      this.$refs.infscroll.trigger();
    },
    onCmCodeChange(newCode) {
      this.code = newCode;
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
    theme(v) {
      if (v) {
        this.$set(this.cmOptions, "theme", "abcdef");
      } else {
        this.$set(this.cmOptions, "theme", "default");
      }
    },
    splitterModel(v) {
      this.$q.localStorage.set("ydb-tables-splitter", v);
    }
  },
  created() {
    let splitterModel = this.$q.localStorage.getItem("ydb-tables-splitter");
    if (splitterModel) {
      this.splitterModel = splitterModel;
    }
  },
  async mounted() {
    await this.getTables();
    if (this.shownTableList[0]) {
      this.populateTable(this.shownTableList[0]);
    }
  }
};
</script>
<style>
@import "~handsontable/dist/handsontable.full.css";
@import "../../../node_modules/codemirror/lib/codemirror.css";
@import "../../../node_modules/codemirror/theme/abcdef.css";
#sqlhottable-dark > .handsontable td {
  background-color: #000000;
}
#sqlhottable-dark > .handsontable th {
  color: #ffffff;
  background-color: rgb(83, 83, 83);
}

#sqlhottable-light > .handsontable td {
  background-color: #ffffff;
}
#sqlhottable-light > .handsontable th {
  color: #000000;
  background-color: rgb(238, 238, 238);
}

#codeMirrorTables > .CodeMirror {
  border: 1px solid #eee;
  height: 150px;
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
