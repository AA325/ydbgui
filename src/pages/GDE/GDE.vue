<template>
  <div class="q-pa-md" :key="pageKey" >
    <div style="padding:20px">
      <span class="text-center" style="font-size:28px;"
        >Global Directory Editor</span
      >
      <q-banner inline-actions class="text-white bg-red" v-if="!saved">
        Your changes have been verified but not saved. Please click Save to
        apply the changes!
        <template v-slot:action>
          <q-btn
            flat
            color="white"
            icon="save"
            label="Save Changes"
            @click="savedata"
          />
        </template>
      </q-banner>
    </div>
    <!-- ********************************** NAMES-START ********************************************* -->
    <div style="padding:10px">
    <q-table
      title="Names"
      :data="items"
      :columns="fields"
      row-key="name"
      bordered
      dense
      virtual-scroll
      :pagination.sync="pagination"
      :rows-per-page-options="[0]"
      :loading="loading"
      tabindex="0"
      selection="single"
      :selected.sync="selectedName"
      :hide-selected-banner="true"
    >
      <template v-slot:top>
        <div style="padding:10px">
          <span class="text-center" style="font-size:21px;">Names</span>
        </div>
        <q-btn round icon="info" size="md" dense flat />
        <q-space />
        <div v-if="selectedName.length > 0">
          <q-btn
            icon="edit"
            label="EDIT"
            @click="
              info(selectedName[0]);
              editNameDialog = true;
            "
            flat
          />
          <q-btn
            icon="delete"
            label="DELETE"
            color="negative"
            flat
             @click="remove(selectedName[0],'name')"
            v-if="show(selectedName[0])"
          />
        </div>
      </template>
      <template v-slot:body-cell-name="props">
        <q-td :props="props">
          <div>
            <q-badge style="max-width:150px" color="primary" :label="props.value" />
          </div>
        </q-td>
      </template>
      <template v-slot:body-cell-region="props">
        <q-td :props="props">
          <div>
            <q-badge
              style="max-width:150px"
              color="positive"
              :label="props.value"
            />
          </div>
        </q-td>
      </template>
      <template v-slot:body-cell-segment="props">
        <q-td :props="props">
          <div>
            <q-badge style="max-width:150px" color="accent" :label="props.value" />
          </div>
        </q-td>
      </template>
    </q-table>
    <q-dialog v-model="editNameDialog" persistent>
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">Edit Name</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input
            outlined
            disable
            label="Name"
            v-model="selectedItem.name.NAME"
            :value="selectedItem.name.NAME"
            :dense="true"
          />
        </q-card-section>
        <q-card-section class="q-pt-none">
          <q-select
            outlined
            id="region"
            :options="Object.keys(regions)"
            label="Region"
            v-model="selectedItem.name.REGION"
            :value="selectedItem.name.REGION"
            :dense="true"
            option-label="text"
            map-options
            emit-value
          />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="OK" @click="ok('name')" />
          <q-btn flat label="Cancel" color="warning" @click="cancel()" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    </div>
  <!-- ********************************** NAMES-END ********************************************* -->
  <!-- ********************************** REGIONS-START ***************************************** -->
 <div style="padding:10px">
 <q-table
      title="Regions"
      :data="regionItems"
      :columns="regionFields"
      row-key="name"
      bordered
      dense
      virtual-scroll
      :pagination.sync="pagination"
      :rows-per-page-options="[0]"
      :loading="loading"
      tabindex="0"
      selection="single"
      :selected.sync="selectedRegion"
      :hide-selected-banner="true"
    >
      <template v-slot:top>
        <div style="padding:10px">
          <span class="text-center" style="font-size:21px;">Regions</span>
        </div>
        <q-btn round icon="info" size="md" dense flat />
        <q-space />
        <div v-if="selectedRegion.length > 0">
                   <q-btn
            icon="preview"
            label="DETAILS"
            @click="
              showDetailsRegionDialog = true;
            "
            flat
          />
          <q-btn
            icon="edit"
            label="EDIT"
            @click="
              info(selectedRegion[0]);
              editRegionDialog = true;
            "
            flat
          />
          <q-btn
            icon="delete"
            label="DELETE"
            color="negative"
            flat
             @click="remove(selectedRegion[0],'region')"
            v-if="show(selectedRegion[0])"
          />
        </div>
      </template>
      <template v-slot:body-cell-name="props">
        <q-td :props="props">
          <div>
            <q-badge style="max-width:100px" color="positive" :label="props.value" />
          </div>
        </q-td>
      </template>
      <template v-slot:body-cell-segment="props">
        <q-td :props="props">
          <div>
            <q-badge style="max-width:100px" color="accent" :label="props.value" />
          </div>
        </q-td>
      </template>
    </q-table>
 </div>
     <q-dialog v-model="editRegionDialog" persistent v-if="selectedRegion.length>0">
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">Edit Region</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input
            outlined
            label="Region"
               id="region"
                v-model="selectedItem.region.NAME"
                :value="selectedItem.region.NAME"
            :dense="true"
          />
        </q-card-section>
        <q-card-section class="q-pt-none">
          <q-select
            outlined
            id="segment"
            :options="Object.keys(segments)"
            label="Segment"
            v-model="selectedItem.region.DYNAMIC_SEGMENT"
            :value="selectedItem.region.DYNAMIC_SEGMENT"
            :dense="true"
            option-label="text"
            map-options
            emit-value
          />
        </q-card-section>
        <q-card-section class="q-pt-none">
           <q-checkbox right-label label="AutoDB" v-model="selectedItem.region.AUTODB" />
        </q-card-section>
        <q-card-section class="q-pt-none">
          <q-input
            outlined
            label="Collation Default"
                v-model="selectedItem.region.COLLATION_DEFAULT"
            :dense="true"
          />
        </q-card-section>
        <q-card-section class="q-pt-none">
           <q-checkbox right-label label="Epoch Taper" v-model="selectedItem.region.EPOCHTAPER" />
           <q-checkbox right-label label="Instance Freeze on Error"  v-model="selectedItem.region.INST_FREEZE_ON_ERROR" />
           <q-checkbox right-label label="Enable Journal" v-model="selectedItem.region.JOURNAL" />
        </q-card-section>
       <q-card-section class="q-pt-none">
          <q-input
            outlined
            label="Auto Switch Limit"
                 v-model="selectedItem.region.AUTOSWITCHLIMIT"
            :dense="true"
          />
        </q-card-section>
               <q-card-section class="q-pt-none">
           <q-checkbox right-label label="Before Image" v-model="selectedItem.region.BEFORE_IMAGE" />
        </q-card-section>
            <q-card-section class="q-pt-none">
          <q-input
            outlined
            label="Journal File Name"
            v-model="selectedItem.region.FILE_NAME"
            :dense="true"
          />
        </q-card-section>
                   <q-card-section class="q-pt-none">
          <q-input
            outlined
            label="Key Size (bytes)"
            v-model="selectedItem.region.KEY_SIZE"
            :dense="true"
          />
        </q-card-section>
         <q-card-section class="q-pt-none">
           <q-checkbox right-label label="Lock Crit Separate" v-model="selectedItem.region.LOCK_CRIT_SEPARATE" />
           <q-checkbox right-label label="Quick Database Rundown"  v-model="selectedItem.region.QDBRUNDOWN" />
        </q-card-section>
        <q-card-section class="q-pt-none">
           <q-checkbox right-label label="Region Stats" v-model="selectedItem.region.STATS" />
           <q-checkbox right-label label="Standard Null Collation" v-model="selectedItem.region.STDNULLCOLL" />
        </q-card-section>
              <q-card-section class="q-pt-none">
          <q-select
            outlined
            :options="regionNullSubscriptsOptions"
            label="Null Subscripts"
            v-model="selectedItem.region.NULL_SUBSCRIPTS"
            :value="selectedItem.region.NULL_SUBSCRIPTS"
            option-label="text"
            map-options
            emit-value
            :dense="true"
          />
        </q-card-section>
        <q-card-section class="q-pt-none">
          <q-input
            outlined
            label="Record Size (bytes)"
            v-model="selectedItem.region.RECORD_SIZE"
            :dense="true"
          />
        </q-card-section>
        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="OK" @click="ok('region')" />
          <q-btn flat label="Cancel" color="warning" @click="cancel()" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="showDetailsRegionDialog" persistent v-if="selectedRegion.length>0">
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">Region {{selectedRegion[0].name}} Details</div>
        </q-card-section>
        <q-card-section>
          <div class="q-pa-md">
    <q-markup-table>
      <tbody>
        <tr>
          <td class="text-left"><b>Journal Extension Count</b></td>
          <td class="text-right">{{selectedRegion[0].extensionCount}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Journal Auto Switch Limit</b></td>
          <td class="text-right">{{selectedRegion[0].autoSwitchLimit}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Default Collation</b></td>
          <td class="text-right">{{selectedRegion[0].defaultCollation}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Stats</b></td>
          <td class="text-right">{{selectedRegion[0].stats}}</td>
        </tr>
     <tr>
          <td class="text-left"><b>AutoDB</b></td>
          <td class="text-right">{{selectedRegion[0].autodb}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Lock Crit</b></td>
          <td class="text-right">{{selectedRegion[0].lockCrit}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Null Subscripts</b></td>
          <td class="text-right">{{selectedRegion[0].nullSubscripts}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Standard Null Collation</b></td>
          <td class="text-right">{{selectedRegion[0].standardNullCollation}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Instance Freeze On Error</b></td>
          <td class="text-right">{{selectedRegion[0].instFreezeOnError}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Qdb Rundown</b></td>
          <td class="text-right">{{selectedRegion[0].qDbRundown}}</td>
        </tr>
        <tr>
          <td class="text-left"><b>Epoch Taper</b></td>
          <td class="text-right">{{selectedRegion[0].epochTaper}}</td>
        </tr>
      </tbody>
    </q-markup-table>
  </div>
        </q-card-section>
        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="OK" @click="showDetailsRegionDialog = false" />
        </q-card-actions>
      </q-card>
    </q-dialog>
 <!-- ********************************** REGIONS-END ***************************************** -->
  </div>
</template>
<script>
import axios from "axios";
import { uid } from 'quasar'
import { required, numeric } from "vuelidate/lib/validators";

const regions = [""];
const segments = [""];
const accessMethods = [""];

export default {
  name: "Gde",
  data() {
    return {
      pageKey:uid(),
      showDetailsRegionDialog:false,
      editNameDialog: false,
      editRegionDialog:false,
      selectedName: [],
      selectedRegion:[],
      loading: true,
      pagination: {
        rowsPerPage: 0
      },
      version: [],
      fromSave: false,
      deletedItems: [],
      unsavedItems: {
        names: [],
        regions: [],
        segments: []
      },
      saved: true,
      savedToggle: false,
      advanced: false,
      advancedToggle: false,
      items: [],
      regionItems: [],
      segmentItems: [],
      names: {},
      errors: "",
      addType: "name",
      addOptions: [
        { text: "Name", value: "name" },
        { text: "Segment", value: "segment" },
        { text: "Region", value: "region" }
      ],
      regionNullSubscriptsOptions: [
        { text: "Always", value: "ALWAYS" },
        { text: "Never", value: "NEVER" },
        { text: "Existing", value: "EXISTING" }
      ],
      regions,
      segments,
      accessMethods,
      map: [],
      fields: [
        {
          name: "name",
          field: "displayName",
          label: "Name",
          sortable: true,
          align: "left"
        },
        {
          name: "region",
          field: "region",
          label: "Region",
          sortable: true,
          align: "left"
        },
        {
          name: "segment",
          field: "segment",
          label: "Segment",
          sortable: true,
          align: "left"
        },
        {
          name: "file",
          field: "file",
          label: "File",
          sortable: true,
          align: "left"
        }
      ],
      regionFields: [
        {
          field:"name",
          name: "name",
          label: "Region",
          sortable: true,
          sortDirection: "desc",
          style:"width:50px"
        },
        {
          name: "segment",
          field:'segment',
          label: "Dynamic Segment",
          sortable: true,
          style:"width:50px"
        },
        {
          field:'keySize',
          name: "keySize",
          label: "Key Size",
          sortable: true,
        },
        {
          field:'recordSize',
          name: "recordSize",
          label: "Record Size",
          sortable: true,
        },
        {
          field:'beforeImage',
          name: "beforeImage",
          label: "Before Image Journaling",
          sortable: true,
        },
        {
          field:'journal',
          name: "journal",
          label: "Journaling Enabled",
          sortable: true,
        },
        {
          field:'journalFileName',
          name: "journalFileName",
          label: "Journal File Name",
          sortable: true,
          sortDirection: "desc",
          class: "fixed-width-font",
        },
        {
          field:'bufferSize',
          name: "bufferSize",
          label: "Journal Buffer Size",
          sortable: true,
        },
        {
          field:'allocation',
          name: "allocation",
          label: "Journal Allocation",
          sortable: true,
        }
      ],
      segmentFields: [
        {
          key: "name",
          label: "Segment",
          sortable: true,
          sortDirection: "desc",
          class: "fixed-width-font",
          thStyle: "width: 5%"
        },
        {
          key: "fileName",
          label: "File Name",
          sortable: true,
          class: "fixed-width-font",
          thStyle: "width: 26%"
        },
        {
          key: "accessMethod",
          label: "Access Method",
          sortable: true,
          thStyle: "width: 7%"
        },
        {
          key: "type",
          label: "File Type",
          sortable: true,
          thStyle: "width: 7%"
        },
        {
          key: "blockSize",
          label: "Block Size",
          sortable: true,
          thStyle: "width: 7%"
        },
        {
          key: "allocation",
          label: "Database Allocation Count",
          sortable: true,
          thStyle: "width: 7%"
        },
        {
          key: "extensionCount",
          label: "Database Extension Count",
          sortable: true,
          thStyle: "width: 7%"
        },
        {
          key: "globalBufferCount",
          label: "Global Buffer Count",
          sortable: true,
          thStyle: "width: 7%"
        },
        {
          key: "lockSpace",
          label: "Lock Space",
          sortable: true,
          thStyle: "width: 7%"
        },
        { key: "actions", label: "Actions", thStyle: "width: 20%" }
      ],
      mapFields: [
        {
          key: "from",
          label: "From",
          sortable: true,
          sortDirection: "desc",
          class: "fixed-width-font"
        },
        {
          key: "to",
          label: "Up to",
          sortable: true,
          class: "fixed-width-font"
        },
        {
          key: "region",
          label: "Region",
          sortable: true,
          class: "fixed-width-font"
        },
        {
          key: "segment",
          label: "Segment",
          sortable: true,
          class: "fixed-width-font"
        },
        {
          key: "file",
          label: "File Name",
          sortable: true,
          class: "fixed-width-font"
        }
      ],
      sortBy: "name",
      sortDesc: false,
      sortDirection: "asc",
      filter: null,
      striped: true,
      hover: true,
      fixed: true,
      selectedIndex: null,
      verified: false,
      modified: false,
      selectedItem: {
        name: {
          NAME: "",
          REGION: "DEFAULT"
        },
        segment: {
          NAME: "",
          FILE_NAME: "",
          ACCESS_METHOD: "BG",
          ALLOCATION: 100,
          ASYNCIO: false,
          BLOCK_SIZE: 1024,
          DEFER_ALLOCATE: true,
          ENCRYPTION_FLAG: false,
          EXTENSION_COUNT: 100,
          GLOBAL_BUFFER_COUNT: 1024,
          LOCK_SPACE: 40,
          MUTEX_SLOTS: 1024,
          RESERVED_BYTES: 0
        },
        region: {
          NAME: "",
          DYNAMIC_SEGMENT: "DEFAULT",
          AUTODB: false,
          COLLATION_DEFAULT: 0,
          EPOCHTAPER: true,
          INST_FREEZE_ON_ERROR: false,
          JOURNAL: false,
          AUTOSWITCHLIMIT: "",
          BEFORE_IMAGE: false,
          FILE_NAME: "",
          KEY_SIZE: 64,
          LOCK_CRIT_SEPARATE: true,
          NULL_SUBSCRIPTS: "ALWAYS",
          QDBRUNDOWN: false,
          RECORD_SIZE: 256,
          STATS: true,
          STDNULLCOLL: true
        }
      }
    };
  },
  computed: {
    sortOptions() {
      const self = this;

      // Create an options list from our fields
      return self.fields
        .filter(f => f.sortable)
        .map(f => ({ text: f.label, value: f.key }));
    }
  },
  mounted() {
    const self = this;
    self.getdata();
  },
  validations() {
    switch (this.addType) {
      case "name":
        return {
          selectedItem: {
            name: {
              NAME: {
                required
              },
              REGION: {
                required
              }
            }
          }
        };
      case "segment":
        return {
          selectedItem: {
            segment: {
              NAME: {
                required
              },
              FILE_NAME: {
                required
              },
              EXTENSION_COUNT: {
                numeric
              },
              ALLOCATION: {
                numeric
              },
              BLOCK_SIZE: {
                numeric
              },
              GLOBAL_BUFFER_COUNT: {
                numeric
              },
              LOCK_SPACE: {
                numeric
              },
              MUTEX_SLOTS: {
                numeric
              },
              RESERVED_BYTES: {
                numeric
              }
            }
          }
        };
      case "region":
        return {
          selectedItem: {
            region: {
              NAME: {
                required
              },
              DYNAMIC_SEGMENT: {
                required
              },
              KEY_SIZE: {
                numeric
              },
              RECORD_SIZE: {
                numeric
              }
            }
          }
        };
      default:
        break;
    }
    return {};
  },
  methods: {
    forceUpper(e, obj, prop) {
      this.$set(obj, prop, e.toUpperCase());
    },
    show(item) {
      switch (item.name) {
        case "*":
          return false;
        case "#": // Also known as Local Locks
          return false;
        default:
          return true;
      }
    },
    info(item) {
      const self = this;
      self.boundItem = item;

      // Make unbound clones of the item object
      self.cachedItem = Object.assign({}, item);
      self.selectedItem = {
        name: {
          NAME: item.name,
          REGION: item.region
        },
        segment: {
          NAME: item.name,
          FILE_NAME: item.fileName,
          ACCESS_METHOD: item.accessMethod,
          ALLOCATION: item.allocation,
          ASYNCIO: item.asyncIO,
          BLOCK_SIZE: item.blockSize,
          DEFER_ALLOCATE: item.deferAllocate,
          ENCRYPTION_FLAG: item.encryption,
          EXTENSION_COUNT: item.extensionCount,
          GLOBAL_BUFFER_COUNT: item.globalBufferCount,
          LOCK_SPACE: item.lockSpace,
          MUTEX_SLOTS: item.mutexSlots,
          RESERVED_BYTES: item.reservedBytes
        },
        region: {
          NAME: item.name,
          DYNAMIC_SEGMENT: item.segment,
          AUTODB: item.autodb,
          COLLATION_DEFAULT: item.collationDefault,
          EPOCHTAPER: item.epochTaper,
          INST_FREEZE_ON_ERROR: item.instFreezeOnError,
          JOURNAL: item.journal,
          AUTOSWITCHLIMIT: item.autoSwitchLimit,
          BEFORE_IMAGE: item.beforeImage,
          FILE_NAME: item.journalFileName,
          KEY_SIZE: item.keySize,
          LOCK_CRIT_SEPARATE: item.lockCrit,
          NULL_SUBSCRIPTS: item.nullSubscripts,
          QDBRUNDOWN: item.qDbRundown,
          RECORD_SIZE: item.recordSize,
          STATS: item.stats,
          STDNULLCOLL: item.standardNullCollation
        }
      };
    },
    okError() {
      const self = this;

      // Reset & Hide the modal - nothing to do here
      self.errors = null;
      self.resetModal();
      self.$refs.modalError.hide();
    },
    cancel() {
      const self = this;

      // Reset the boundItem to the copy we made earlier and hide the modal
      // this.selectedItem = Object.assign(this.boundItem, this.cachedItem);
      self.errors = null;
      self.resetModal();

      // hide all the modals
      self.hideModals();
    },
    focusElement() {
      const self = this;
      self.$refs.infoName.focus();
    },
    resetModal() {
      const self = this;

      // Clear out anything in selected item and set boundItem, CachedItem and selectedIndex to null
      // Only reset if errors isn't set
      if (self.errors === null) {
        self.selectedItem = {
          name: {
            NAME: "",
            REGION: "DEFAULT"
          },
          segment: {
            NAME: "",
            FILE_NAME: "",
            ACCESS_METHOD: "BG",
            ALLOCATION: 100,
            ASYNCIO: false,
            BLOCK_SIZE: 1024,
            DEFER_ALLOCATE: true,
            ENCRYPTION_FLAG: false,
            EXTENSION_COUNT: 100,
            GLOBAL_BUFFER_COUNT: 1024,
            LOCK_SPACE: 40,
            MUTEX_SLOTS: 1024,
            RESERVED_BYTES: 0
          },
          region: {
            NAME: "",
            DYNAMIC_SEGMENT: "DEFAULT",
            AUTODB: false,
            COLLATION_DEFAULT: 0,
            EPOCHTAPER: true,
            INST_FREEZE_ON_ERROR: false,
            JOURNAL: false,
            AUTOSWITCHLIMIT: "",
            BEFORE_IMAGE: false,
            FILE_NAME: "",
            KEY_SIZE: 64,
            LOCK_CRIT_SEPARATE: true,
            NULL_SUBSCRIPTS: "ALWAYS",
            QDBRUNDOWN: false,
            RECORD_SIZE: 256,
            STATS: true,
            STDNULLCOLL: true
          }
        };
        self.boundItem = null;
        self.cachedItem = null;
        self.selectedIndex = null;
      }
    },
    makeitems() {
      const self = this;

      // Builds a filled out items array combining information in regions, segments, and names
      const newItems = [];
      Object.keys(self.names).forEach(name => {
        if (name === "#") {
          self.displayName = "Local Locks";
        } else {
          self.displayName = name;
        }
        const displayItem = {
          displayName: self.displayName,
          name,
          region: self.names[name],
          segment: self.regions[self.names[name]].DYNAMIC_SEGMENT,
          file:
            self.segments[self.regions[self.names[name]].DYNAMIC_SEGMENT]
              .FILE_NAME
        };
        newItems.push(displayItem);
      });
      self.items = Object.assign([], newItems);

      // Build items array for regions
      const newRegions = [];
      Object.keys(self.regions).forEach(name => {
        const displayRegion = {
          name,
          segment: self.regions[name].DYNAMIC_SEGMENT,
          defaultCollation: self.regions[name].COLLATION_DEFAULT,
          recordSize: self.regions[name].RECORD_SIZE,
          keySize: self.regions[name].KEY_SIZE,
          nullSubscripts: self.regions[name].NULL_SUBSCRIPTS,
          standardNullCollation: self.regions[name].STDNULLCOLL,
          journal: self.regions[name].JOURNAL,
          instFreezeOnError: self.regions[name].INST_FREEZE_ON_ERROR,
          qDbRundown: self.regions[name].QDBRUNDOWN,
          epochTaper: self.regions[name].EPOCHTAPER,
          autodb: self.regions[name].AUTODB,
          stats: self.regions[name].STATS,
          lockCrit: self.regions[name].LOCK_CRIT_SEPARATE,
          journalFileName: self.regions[name].FILE_NAME,
          beforeImage: self.regions[name].BEFORE_IMAGE,
          bufferSize: self.regions[name].BUFFER_SIZE,
          allocation: self.regions[name].ALLOCATION,
          extensionCount: self.regions[name].EXTENSION,
          autoSwitchLimit: self.regions[name].AUTOSWITCHLIMIT
        };
        newRegions.push(displayRegion);
      });
      self.regionItems = Object.assign([], newRegions);

      // Build items array for segments
      const newSegments = [];
      Object.keys(self.segments).forEach(name => {
        const displaySegment = {
          name,
          fileName: self.segments[name].FILE_NAME,
          accessMethod: self.segments[name].ACCESS_METHOD,
          type: self.segments[name].FILE_TYPE,
          allocation: self.segments[name].ALLOCATION,
          blockSize: self.segments[name].BLOCK_SIZE,
          extensionCount: self.segments[name].EXTENSION_COUNT,
          globalBufferCount: self.segments[name].GLOBAL_BUFFER_COUNT,
          lockSpace: self.segments[name].LOCK_SPACE,
          reservedBytes: self.segments[name].RESERVED_BYTES,
          encryption: self.segments[name].ENCRYPTION_FLAG,
          mutexSlots: self.segments[name].MUTEX_SLOTS,
          deferAllocate: self.segments[name].DEFER_ALLOCATE,
          asyncIO: self.segments[name].ASYNCIO
        };
        newSegments.push(displaySegment);
      });
      self.segmentItems = Object.assign([], newSegments);
    },
    ok(type) {
      let item;
      const self = this;
      self.saved = false;
      self.savedToggle = !self.saved;

      // Move data from the modal to the correct object behind the scenes
      switch (type) {
        case "name":
          self.names[self.selectedItem.name.NAME] =
            self.selectedItem.name.REGION;
          self.unsavedItems.names.push(self.selectedItem.name.NAME);
          break;
        case "segment":
          item = Object.assign({}, self.selectedItem.segment);
          delete item.NAME;
          self.segments[self.selectedItem.segment.NAME] = item;
          self.unsavedItems.segments.push(self.selectedItem.segment.NAME);
          break;
        case "region":
          item = Object.assign({}, self.selectedItem.region);
          delete item.NAME;
          self.regions[self.selectedItem.region.NAME] = item;
          self.unsavedItems.regions.push(self.selectedItem.region.NAME);
          break;
        default:
          break;
      }

      // Verify the data, but don't save it
      self.verifydata();

      // hide all the modals
      self.hideModals();
      self.pageKey = uid()
       self.selectedName = []
      self.selectedRegion = []
    },
    hideModals() {
      const self = this;

      // Put all modals here to be hidden when OK or Cancel is pressed
      self.editNameDialog = false; // Edit Name Modal
      self.editRegionDialog = false;
      // self.$refs.modalAdd.hide();
      // self.$refs.modalEditName.hide();
      // self.$refs.modalEditRegion.hide();
      // self.$refs.modalEditSegment.hide();
    },
    remove(item, type) {
      const self = this;
      let index = 0;
      let unsavedItemsIndex = 0;
      self.saved = false;
      self.savedToggle = !self.saved;

      switch (type) {
        case "name":
          unsavedItemsIndex = self.unsavedItems.names.findIndex(
            name => name === item.name
          );
          if (unsavedItemsIndex === -1) {
            self.deletedItems.push({
              name: {
                NAME: item.name
              }
            });
          } else {
            self.unsavedItems.names.splice(unsavedItemsIndex, 1);
          }
          delete self.names[item.name];
          index = self.items.findIndex(name => name.name === item.name);
          self.items.splice(index, 1);
          break;
        case "segment":
          // disable eslint max-len for next line so it looks like all other findIndex calls
          /* eslint-disable max-len */
          unsavedItemsIndex = self.unsavedItems.segments.findIndex(
            segment => segment === item.name
          );
          if (unsavedItemsIndex === -1) {
            self.deletedItems.push({
              segment: {
                SEGMENT: item.name
              }
            });
          } else {
            self.unsavedItems.segments.splice(unsavedItemsIndex, 1);
          }
          delete self.segments[item.name];
          index = self.segmentItems.findIndex(
            segment => segment.name === item.name
          );
          self.segmentItems.splice(index, 1);
          break;
        case "region":
          unsavedItemsIndex = self.unsavedItems.regions.findIndex(
            region => region === item.name
          );
          if (unsavedItemsIndex === -1) {
            self.deletedItems.push({
              region: {
                REGION: item.name
              }
            });
          } else {
            self.unsavedItems.regions.splice(unsavedItemsIndex, 1);
          }
          delete self.regions[item.name];
          index = self.regionItems.findIndex(
            region => region.name === item.name
          );
          self.regionItems.splice(index, 1);
          break;
        default:
          break;
      }
    },
    getdata() {
      const self = this;
      axios({
        method: "GET",
        url: "/gde/get"
      }).then(
        result => {
          self.names = result.data.names;
          self.regions = result.data.regions;
          self.segments = result.data.segments;
          self.accessMethods = result.data.accessMethods;
          self.map = result.data.map;
          self.makeitems();
          self.loading = false;
        },
        error => {
          self.errors = JSON.stringify(error);
          self.$refs.modalError.show();
        }
      );
      self.verified = true;
    },
    verifydata() {
      const self = this;
      self.verified = false;
      axios({
        method: "POST",
        url: "/gde/verify",
        data: {
          names: self.names,
          regions: self.regions,
          segments: self.segments
        }
      })
        .then(result => {
          if (result.data.verifyStatus) {
            self.verified = true;
            return Promise.resolve(self.makeitems());
          }
          if (
            !self.fromSave &&
            result.data.errors.length === 1 &&
            result.data.errors[0].includes("GDE-I-MAPBAD")
          ) {
            self.verified = true;
            return Promise.resolve(self.makeitems());
          }
          return Promise.reject(result.data.errors);
        })
        .catch(error => {
          if (!self.errors) {
            self.errors = JSON.stringify(error);
          }
          switch (self.addType) {
            case "name":
              delete self.names[self.selectedItem.name.NAME];
              break;
            case "segment":
              delete self.segments[self.selectedItem.segment.NAME];
              break;
            case "region":
              delete self.regions[this.selectedItem.region.NAME];
              break;
            default:
              break;
          }
          self.verified = false;
          self.$refs.modalError.show();
        });
      self.verified = true;
    },
    async savedata() {
      const self = this;
      axios({
        method: "POST",
        url: "/gde/save",
        data: {
          names: self.names,
          regions: self.regions,
          segments: self.segments,
          deletedItems: self.deletedItems
        }
      })
        .then(result => {
          self.deletedItems = [];
          self.fromSave = true;
          if (result.data.verifyStatus) {
            self.getdata();
            self.verified = true;
            self.modified = false;
            self.saved = true;
            self.savedToggle = !self.saved;
            self.fromSave = false;
            self.unsavedItems = {
              names: [],
              regions: [],
              segments: []
            };
            self.notify("Data Saved!", true);
            return Promise.resolve(true);
          }
          self.fromSave = false;
          self.notify("Data Not Saved!", false);
          return Promise.reject(result.data.errors);
        })
        .catch(error => {
          self.deletedItems = [];
          if (!self.errors) {
            self.errors = JSON.stringify(error);
          }
          self.saved = false;
          self.saved = !self.saved;
          self.verified = false;
          self.notify("Data Not Saved!", false);
          // self.$refs.modalError.show();
        });
    },
    notify(message, type) {
      let color = "positive";
      if (!type) {
        color = "negative";
      }
      this.$q.notify({
        message: message,
        color: color
      });
    }
  }
};
</script>
