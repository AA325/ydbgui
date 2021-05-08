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
      <q-breadcrumbs-el label="System Administration" />
      <q-breadcrumbs-el  label="Running Processes" />
    </q-breadcrumbs>
       <q-btn round style="margin-right:10px" size="md" icon="refresh"  :color="!$q.dark.isActive ? 'purple' : 'orange'"  @click="refreshProcesses">
        <q-tooltip>
        Refresh running processes
        </q-tooltip>
      </q-btn>   
      <span class="text-center" style="font-size:28px;padding:25px"
        ></span
      >
    </div>
    <div class="row flex flex-center">
        <div class="col-auto">
    <div v-if="loading">
        <q-spinner-dots
          :color="$q.dark.isActive ? 'purple' : 'orange'"
          size="16em"
        />
        <q-tooltip :offset="[0, 8]">QSpinnerGears</q-tooltip>
      </div>
    <q-markup-table flat bordered v-if="!loading" style="max-height:calc(100vh - 190px)">
      <thead :class="$q.dark.isActive ? 'bg-purple text-white' : 'bg-orange text-white'">
        <tr>
          <th colspan="5">
            <div class="row no-wrap items-center">
              <q-img
                style="width: 70px"
                :ratio="1"
                class="rounded-borders"
               src="~assets/uc-1.png"
              />

              <div class="text-h4 q-ml-md text-white">Running Processes</div>
            </div>
          </th>
        </tr>
        <tr>
          <th class="text-left">PID</th>
          <th class="text-left">Process Name</th>
          <th class="text-left">Device</th>
          <th class="text-left">Routine</th>
          <th class="text-left">CPU Time</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="process in processes" :key="'pid-'+process.PID">
          <td class="text-left" v-if="typeof process.PID ==='number'"><router-link :to="'process/'+process.PID" :class="'text-orange'">{{process.PID}}</router-link></td>
          <td class="text-left" v-else>{{process.PID}}</td>
          <td class="text-left">{{process.PN}}</td>
          <td class="text-left">{{process.DV}}</td>
          <td class="text-left">{{process.RTN}}</td>
          <td class="text-left">{{process.CTM}}</td>
        </tr>
      </tbody>
    </q-markup-table>
        </div>
    </div>
     </div>
</template>
<script>

export default {
    name:'Processes',
    data(){
        return {
            processes:[],
            loading:false
        }
    },
    async mounted(){
        await this.refreshProcesses()
    },
    methods:{
        async refreshProcesses(){
            this.loading=true
            let data = await this.$M('GETPROCESSLIST^%YDBWEBPRSC')
            this.loading=false
            if (data && data.STATUS){
                this.processes = data.PROCESSES
            } else {
                this.$q.notify({
                    message:'Could not get current processes, please try again!',
                    color:'negative'
                })
            }
        },
    }
}
</script>
<style scoped>

</style>
