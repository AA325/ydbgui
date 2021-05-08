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

const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Index.vue') },
      { path: 'gde', component: () => import('src/pages/GDE/GDE.vue') },
      { path: 'routines', component: () => import('src/pages/Routines/Routines.vue') },
      { path: 'globals', component: () => import('src/pages/Globals/Globals.vue') },
      { path: 'octo-sql', component: () => import('src/pages/OCTOSQL/OCTOSQL.vue') },
      { path: 'processes', component: () => import('src/pages/Processes/Processes.vue') },
      { path: 'process/:pid', component: () => import('src/pages/Processes/ProcessDetails.vue') },
    ]
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '*',
    component: () => import('pages/Error404.vue')
  }
]

export default routes
