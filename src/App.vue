<!--
/*
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
*/
-->
<template>
  <div id="q-app">
    <router-view />
  </div>
</template>
<script>
export default {
  name: 'App'
}
</script>
<style>
body ::-webkit-scrollbar-track
{
    -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
    border-radius: 12px;
}

body ::-webkit-scrollbar
{
    width: 12px;
    height: 10px;
}

body ::-webkit-scrollbar-thumb
{
    border-radius: 10px;
    -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
    background-color:#85858590
}
.body--dark ::-webkit-scrollbar-track
{
    -webkit-box-shadow: inset 0 0 6px rgba(255, 255, 255, 0.3)!important;
    border-radius: 12px!important;
}

.body--dark ::-webkit-scrollbar
{
    width: 12px!important;
    height: 10px!important;
}

.body--dark ::-webkit-scrollbar-thumb
{
    border-radius: 10px!important;
    -webkit-box-shadow: inset 0 0 6px rgba(255, 255, 255, 0.3)!important;
    background-color:#80808090
}
</style>

