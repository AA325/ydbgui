
const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Index.vue') },
      { path: 'gde', component: () => import('src/pages/GDE/GDE.vue') },
      { path: 'routines', component: () => import('src/pages/Routines/Routines.vue') },
      { path: 'globals', component: () => import('src/pages/Globals/Globals.vue') },
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
