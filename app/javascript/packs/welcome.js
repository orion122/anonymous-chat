import Vue from 'vue/dist/vue.esm'
import App from '../app'
import Welcome from '../welcome.vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const router = new VueRouter({
    routes: [
        { path:'/', component: Welcome }
    ]
})

// document.addEventListener('DOMContentLoaded', () => {
//     const el = document.body.appendChild(document.createElement('welcome'))
//     const app = new Vue({
//         el,
//         render: h => h(App),
//         router
//     })
//
//     console.log('app')
// })

const app = new Vue({
    router
}).$mount('#app')